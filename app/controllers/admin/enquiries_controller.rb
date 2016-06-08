class Admin::EnquiriesController < Admin::BaseController


  def set_page_title
    @page_title = "Enquiries Management"
  end

  def index
    @enquiries = Enquiry.active.order('created_at DESC')
    #render json: @enquiries
  end

  def show
    @enquiry = Enquiry.find(params[:id])
  end

  def destroy
    @enquiry = Enquiry.find(params[:id])
    if @enquiry
      @enquiry.update_attributes(is_active: false)
    end
    redirect_to admin_enquiries_path
  end
end
