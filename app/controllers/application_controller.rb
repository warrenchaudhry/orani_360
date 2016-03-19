class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  before_action :set_page_title

  def home
    logged_in? ? redirect_to(users_path) : redirect_to(login_path)
  end

  def set_page_title
    @page_title = controller_name.humanize.titleize
  end

  private
  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end
end
