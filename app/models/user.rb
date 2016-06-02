class User < ActiveRecord::Base
  rolify
  authenticates_with_sorcery!

  #has_many :contact_numbers, as: :contactable,  dependent: :destroy
  #accepts_nested_attributes_for :contact_numbers, allow_destroy: true, :reject_if => :all_blank
  attr_accessor :is_admin, :role
  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: EMAIL_REGEX
  validates :first_name, :last_name, :mi, :gender, presence: true
  validates :role, :password, :password_confirmation, presence: true, on: :create
  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }
  validates_date :birthdate, on_or_before: lambda { Date.current }, allow_blank: true

  after_create :set_role
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
            name << "#{send(attr)}."
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

  def user_roles
    role = 'N/A'
    if roles.any?
      role = roles.collect {|r| r.name.titleize}.to_sentence
    end
    role
  end

  def set_role
    if role.present?
      self.add_role(role)
    end
  end

  def is_admin?
    self.has_role? :admin
  end

  def is_editor?
    self.has_role? :editor
  end

  def display_name
    full_name('display')
  end

  class << self

    def display_attributes
      %w{display_name email user_roles last_login_from_ip_address last_login_at}
    end

    def categories
      CATEGORIES.collect {|reg| [ "#{reg[:name]} (P#{reg[:price]})", reg[:name] ]  }
    end

    def mail_recipients
      where(should_receive_email: true).pluck(:email)
    end

  end
end
