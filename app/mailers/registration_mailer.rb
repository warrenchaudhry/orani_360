class RegistrationMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  def notify_admins(registration)
    @registration = registration
    if @registration.attachment.present?
      attachments.inline[@registration.attachment_file_name] = open(@registration.attachment.url(:medium)).read
    end
    recipients = User.mail_recipients
    #recipients = %w{warrenchaudhry@gmail.com}
    if recipients.any?
      mail( to: recipients, subject: 'New Registration - Orani 360 Half Marathon')
    end
  end
end
