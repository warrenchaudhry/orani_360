class Enquiry < ActiveRecord::Base

  include ActionView::Helpers::SanitizeHelper
  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates_presence_of :name, :email, :message
  validates_format_of :email, :with => EMAIL_REGEX, allow_blank: true
  before_save :sanitize_attribs

  #belongs_to  :user, class_name: 'User', foreign_key: :replied_by

  scope :active, ->{where(is_active: true)}


  class << self

    def display_attributes
      %w{name email ip_address sent_at}
    end

  end

  def sanitize_attribs
    self.name = name.strip
    self.email = email.strip.downcase
    self.message = strip_tags(message)
  end

  # def respondent
  #   if self.user
  #     self.user.full_name
  #   end
  #   return nil unless self.user
  # end


end