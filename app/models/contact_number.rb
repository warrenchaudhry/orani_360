class ContactNumber < ActiveRecord::Base
  validates :contact_number, :contact_type, presence: true
  belongs_to :contactable, polymorphic: true
  TYPES = %w{Home Mobile Work Business Others}
end
