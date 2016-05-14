class Admin::RegistrationsController < Admin::BaseController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :check_role, only: [:approve, :destroy]

  def set_page_title
    @page_title = "Registrations Management"
  end
  # GET /pages
  # GET /pages.json
  def index
    @registrations = Registration.all
  end

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)

    respond_to do |format|
      if @registration.save
        format.html { redirect_to @registration, notice: 'Registration was successfully created.' }
        format.json { render :show, status: :created, location: @registration }
      else
        format.html { render :new }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to admin_registrations_path, notice: 'Page was successfully destroyed.' }
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
                                           :attachment )
    end
end
