class Admin::BaseController < ApplicationController

  before_action :require_login
  before_action :set_page_title

  def home
    logged_in? ? redirect_to(admin_dashboards_path) : redirect_to(admin_login_path)
  end

  def set_page_title
    @page_title = controller_name.humanize.titleize
  end

  private
  def not_authenticated
    redirect_to admin_login_path, alert: "Please login first"
  end

end