class MainController < ApplicationController
  layout 'plain'
  before_action :build_meta

  def build_meta
    @meta = {
      title: 'Orani 360 - Half Marathon',
      description: 'August 14, 2016 | Orani Plaza | Deadline of registration is on July 31, 2016',
      url: 'http://orani360.inbox.com.ph',
      image: view_context.asset_url('360brand.png')
    }
  end

  def index
  end

  def pages
    if params[:page_url] == 'runners'
      @runners = Registration.active.approved.where.not(registration_no: nil).order('registration_no ASC')
      @meta = {
        title: 'Orani 360 - Half Marathon | Registered Runners',
        url: 'http://orani360.inbox.com.ph/runners',
        image: view_context.asset_url('runners_banner.jpg')
      }
    elsif params[:page_url] == 'about'
      @meta = {
        title: 'Orani 360 - Half Marathon | About',
        url: 'http://orani360.inbox.com.ph/about'
      }
    elsif params[:page_url].underscore == 'contact_us'
      @enquiry = Enquiry.new
      @meta = {
        title: 'Orani 360 - Half Marathon | Contact Us',
        url: 'http://orani360.inbox.com.ph/contact-us'
      }
    end
    render "main/pages/#{params[:page_url].underscore}"
  end


  def send_enquiry
    @enquiry = Enquiry.new(enquiry_params)
    if @enquiry.valid?
      @enquiry.sent_at = Time.now
      @enquiry.ip_address = request.remote_ip
      @enquiry.save!
      EnquiryMailer.send_enquiry(@enquiry.name, @enquiry.email, @enquiry.message).deliver
      flash[:success] = 'Thank you for reaching out to us. Our support team will make a follow up on your email.'
      redirect_to '/contact-us'
    else
      render "main/pages/contact_us"
    end

  end

  private

  def enquiry_params
    params.require(:enquiry).permit(:name, :email, :message)
  end
end
