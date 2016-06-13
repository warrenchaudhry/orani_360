class EnquiryMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def send_enquiry(name, email, message)
    @name = name
    @email = email
    @message = message
    recipients = User.mail_recipients
    if recipients.any?
      mail to: recipients, subject: "A new enquiry has been made"
    end
  end
end
