class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.order(:last_name).all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      flash[:success] = 'User has been created'
      redirect_to admin_users_path
    else
      p @user.errors.full_messages
      render :new
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'User has been updated'
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :mi, :suffix, :email, :gender, :birthdate, :role, :password, :password_confirmation, :active, :should_receive_email)
    end
end
