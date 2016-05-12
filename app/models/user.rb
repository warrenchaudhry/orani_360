class User < ActiveRecord::Base
  rolify
  authenticates_with_sorcery!

  #has_many :contact_numbers, as: :contactable,  dependent: :destroy
  #accepts_nested_attributes_for :contact_numbers, allow_destroy: true, :reject_if => :all_blank
  attr_accessor :is_admin
  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: EMAIL_REGEX
  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

  def to_s
    full_name
  end

  def full_name(scope = nil)
    if scope == 'reverse'
      "#{last_name}, #{first_name} #{mi.present? ? "#{mi}." : nil} #{suffix}".squish
    elsif scope == 'display'
      puts 'Im on display'
      name = []
      [:first_name, :mi, :last_name, :suffix].each do |attr|
        if send(attr).present?
          if attr == :mi
            name << "#{attr}."
          else
            name << send(attr)
          end
        end
      end
      name.join(' ').gsub(/\b\w/){$&.upcase}
    else
      [first_name, mi, last_name, suffix].select(&:present?).join(' ').gsub(/\b\w/){$&.upcase}
    end
  end
end
