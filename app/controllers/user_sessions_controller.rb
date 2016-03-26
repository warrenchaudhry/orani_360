class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  layout 'session'
  def new
    @page_title = "Login"
    if logged_in?
      redirect_to dashboards_path
      return
    end
    @user = User.new
  end

  def create
    if @user = login(params[:user][:email], params[:user][:password])
      redirect_to(dashboards_path, notice: 'Login successful')
    else
      flash.now[:error] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:users, notice: 'Logged out!')
  end
end