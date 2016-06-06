class RejectedRegistation < ActiveRecord::Base
  belongs_to :registration
  validates :reason, :registration_id,  presence: true
end
