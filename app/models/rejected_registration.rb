class RejectedRegistration < ActiveRecord::Base
  belongs_to :registration
  belongs_to :disapprover, class_name: 'User', foreign_key: :rejected_by
  validates :reason, :registration_id,  presence: true

  after_create :send_rejection_notification


  def send_rejection_notification
    if RegistrationMailer.reject(self.registration).deliver
      self.sent = true
      self.sent_at = Time.now
      self.save
    end
  end
end
