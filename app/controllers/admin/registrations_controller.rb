class Admin::RegistrationsController < Admin::BaseController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :check_role, only: [:approve, :destroy]

  def set_page_title
    @page_title = "Registrations Management"
  end
  # GET /pages
  # GET /pages.json
  def index
    params[:page] ||= 1
    params[:per] ||= 25
    registrations = Registration.active.order('date_registered')
    if params[:q].present?
      keyword = params[:q].strip.downcase
      registrations = registrations.where('TRIM(LOWER(first_name)) LIKE ? OR TRIM(LOWER(middle_name)) LIKE ? OR TRIM(LOWER(last_name)) LIKE ?', "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")
    end
    if params[:cat].present?
      registrations = registrations.where(category: params[:cat])
    end
    @registrations = registrations.order('first_name').page(params[:page]).per(params[:per])
  end

  def new
    @registration = Registration.new
    @registration.admin_encoded = true
    @registration.is_paid_on_site = true
    @registration.date_registered = Date.current
  end

  def edit

  end

  def show

  end

  def create
    @registration = Registration.new(registration_params)
    @registration.admin_encoded = true
    @registration.approved = true
    @registration.approved_at = Time.zone.now
    @registration.approved_by = current_user.id
    respond_to do |format|
      if @registration.save
        format.html { redirect_to admin_registrations_path, notice: 'Registration was successfully created.' }
        format.json { render :show, status: :created, location: @registration }
      else
        format.html { render :new }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registration.update(registration_params)
        format.html { redirect_to admin_registrations_path, notice: 'Registration was successfully updated.' }
        format.json { render :show, status: :ok, location: @registration }
      else
        format.html { render :edit }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registration.update_attributes(active: false)
    respond_to do |format|
      format.html { redirect_to admin_registrations_path, notice: 'Registration was successfully deleted.' }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def check_role
      unless current_user.has_role?(:admin)
        redirect_to admin_registrations_path, notice: 'You are not allowed to perform this action.'
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:registration_no, :email, :first_name, :last_name, :middle_name, :occupation, :grp_org_comp,
                                           :residential_address, :gender, :birth_date, :contact_numbers, :emergency_contact_name,
                                           :emergency_contact_number, :category, :singlet, :terms_accepted, :receive_newsletters, :approved,
                                           :attachment, :date_registered, :admin_encoded, :is_paid_on_site, :bank_name, :is_free_registraion, :discount, :remarks)
    end
end
