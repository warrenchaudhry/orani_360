class RegistrationMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  def notify_admins(registration)
    @registration = registration
    # puts @registration.attachment.url(:medium)
    # if @registration.attachment.present?
    #   attachments.inline[@registration.attachment_file_name] = File.read( open("#{@registration.attachment}") )
    # end
    recipients = User.mail_recipients
    #recipients = %w{warrenchaudhry@gmail.com}
    if recipients.any?
      mail( to: recipients, subject: 'New Registration - Orani 360 Half Marathon')
    end
  end

  def approve(registration)
    @registration = registration
    recipients = User.mail_recipients
    if @registration.email.present?
      mail( to: @registration.email, bcc: recipients, subject: 'Your registration for Orani 360 Half Marathon has been approved!')
    end
  end

  def reject(registration)
    @registration = registration
    recipients = User.mail_recipients
    if @registration.email.present?
      mail( to: @registration.email, bcc: recipients, subject: 'Your registration for Orani 360 Half Marathon has been disapproved!')
    end
  end
end
