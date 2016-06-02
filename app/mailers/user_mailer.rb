class UserMailer < ApplicationMailer

  def reset_password(user)
    @user = User.find(user.id)
    #@url = edit_password_reset_url(@user.reset_password_token)
    mail( to: user.email, subject: 'Your password has been reset')
  end

  def registration_follow_up(registration)

  end
end
