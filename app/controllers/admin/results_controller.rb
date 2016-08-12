class Admin::ResultsController < Admin::BaseController
  before_action :set_result, only: [:show, :edit, :update, :destroy]
  #before_action :check_role, only: [:destroy]

  def set_page_title
    @page_title = "Race Results Management"
  end
  # GET /pages
  # GET /pages.json
  def index
    params[:page] ||= 1
    params[:per] ||= 25
    params[:sort] ||= 'time_finished'
    params[:direction] ||= 'ASC'
    registrations = Registration.active.approved.includes(:result).references(:all)
    .select('registrations.id, registrations.registration_no, registrations.last_name, registrations.middle_name, registrations.first_name, registrations.category, registrations.gender, registrations.residential_address, results.time_finished as time_finished')
    .where(category: %w(21K 10K)).order('time_finished')
    sort_order = params[:sort] == 'display_name' ? 'last_name' : params[:sort]
    if params[:q].present?
      keyword = params[:q].strip.downcase
      registrations = registrations.where('TRIM(LOWER(first_name)) LIKE :keyword OR TRIM(LOWER(middle_name)) LIKE :keyword OR TRIM(LOWER(last_name)) LIKE :keyword OR TRIM(LOWER(registration_no)) LIKE :keyword OR TRIM(LOWER(grp_org_comp)) LIKE :keyword OR TRIM(LOWER(residential_address)) LIKE :keyword', keyword: "%#{keyword}%")
    end
    if params[:cat].present?
      registrations = registrations.where(category: params[:cat])
    end
    if params[:gender].present? && %w(Male Female).include?(params[:gender])
      registrations = registrations.where(gender: params[:gender])
    end
    @registrations = registrations.reorder("#{sort_order} #{params[:direction]}").page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html
      format.xlsx do
        @registrations = Registration.active.approved.includes(:approver).order('registration_no')
        response.headers['Content-Disposition'] = 'attachment; filename="registrations_report.xlsx"'
      end
    end
  end

  def new
    @registration = Registration.find(params[:registration_id])
    if @registration
      @result = @registration.build_result(category: @registration.category)
      @result.default_duration
    else
      redirect_to admin_results_path(notice: 'Invalid racer record!')
    end
  end

  def edit
    @registration = @result.registration
    @result.duration_to_params
  end

  def show
    @registration = @result.registration
  end

  def create
    @result = Result.new(result_params)
    @registration = Registration.find(@result.registration_id)
    if @registration
      @result.category = @registration.category
    end
    #render json: params
    respond_to do |format|
      if @result.save
        format.html { redirect_to admin_results_path, notice: 'Result was successfully created.' }
        format.json { render :show, status: :created, location: @result }
      else
        format.html { render :new }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    @registration = @result.registration
    respond_to do |format|
      if @result.update(result_params)
        format.html { redirect_to admin_results_path, notice: 'Result was successfully updated.' }
        format.json { render :show, status: :ok, location: @result }
      else
        format.html { render :edit }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @result.destroy
    respond_to do |format|
      format.html { redirect_to admin_results_path, notice: 'Result was successfully deleted.' }
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
    def set_result
      @result = Result.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(:registration_id, :time_finished, :remarks, :hours, :minutes, :seconds)
    end
end
