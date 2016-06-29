class Registration < ActiveRecord::Base

  CATEGORIES = [
    {name: '3K', price: 250},
    {name: '5K', price: 300},
    {name: '10K', price: 450},
    {name: '21K', price: 700}
  ]
  SINGLET = %w(XS SM MD LG XL XXL)
  STATUS = %w(Approved Pending Rejected)
  # has_many :deposit_attachments,  dependent: :destroy
  # accepts_nested_attributes_for :deposit_attachments, allow_destroy: true, :reject_if => :all_blank
  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #validates , presence: true, uniqueness: { case_sensitive: false }, format: EMAIL_REGEX
  attr_accessor :for_approval
  validates :first_name, :last_name, :gender, :category, :singlet, presence: true
  validates :email, :residential_address, :birth_date, :contact_numbers,
           :emergency_contact_name, :emergency_contact_number, :bank_name, presence: true, unless: 'is_paid_on_site?'
  validates :registration_no, :date_registered, presence: true, if: 'admin_encoded? || for_approval.present?'
  validates :date_registered, presence: true, if: 'admin_encoded?'
  validates_uniqueness_of :registration_no, allow_blank: true, conditions: -> { where(active: true) }
  validates :email, format: EMAIL_REGEX, allow_blank: true
  validates_date :birth_date, on_or_before: lambda { Date.current }, allow_blank: true
  validate :check_if_terms_accepted, on: :create, unless: 'admin_encoded.present?'
  has_attached_file :attachment, :styles => {
      :large => "1400x550>",
      :medium => "960x300>",
      :thumb => "120x120>"
  },
  :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate },
  :url  => "/payment_attachments/:id/:style/:basename.:extension",
  :path => "/payment_attachments/:id/:style/:basename.:extension",
  :default_url => "/assets/no-image.png",
  :default_style => :thumb
  has_one :rejected_registration
  accepts_nested_attributes_for :rejected_registration
  STATUS.each do |s|
    scope s.downcase.to_sym, -> { where(status: s.downcase) }
  end
  scope :active, -> {where(active: true)}
  scope :approved, -> {where(status: 'approved')}
  scope :rejected, -> {where(status: 'rejected')}
  scope :pending, -> {where(status: 'pending')}
  scope :free, -> {where(is_free_registraion: true)}
  validates_attachment_presence :attachment, unless: 'is_paid_on_site?'
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  before_post_process :transliterate_file_name
  before_save :sanitize_string_fields
  before_save :assign_defaults
  after_create :notify_admins, unless: 'admin_encoded.present?'
  belongs_to :approver, class_name: 'User', foreign_key: :approved_by

  HUMANIZED_ATTRIBUTES = {
      grp_org_comp: 'Group / Org. / Company',
  }

  class << self

    def display_attributes
      %w{registration_no display_name category gender status paid_online updated_at}
    end

    def categories
      CATEGORIES.collect {|reg| [ "#{reg[:name]} (P#{reg[:price]})", reg[:name] ]  }
    end

    def category_names
      CATEGORIES.collect {|reg| reg[:name] }
    end

    def details_attributes
      ["registration_no", "category", "singlet", "email", "last_name", "first_name", "middle_name", "gender", "date_registered", "birth_date", "age", "age_on_race_day", "occupation", "grp_org_comp", "residential_address", "contact_numbers", "emergency_contact_name", "emergency_contact_number"]
    end

    def human_attribute_name(attr, options={})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    def fetch_by_category(category)
      where(category: category)
    end

    def total
      sum(:amount)
    end

  end

  def assign_defaults
    self.age = Toolbox.age(birth_date) if birth_date.present?
    self.age_on_race_day = Toolbox.age(birth_date, '2016-08-14'.to_date) if birth_date.present?
    self.terms_accepted_at = Time.zone.now if terms_accepted?
    self.amount = assign_registration_amount
  end

  def assign_registration_amount
    amount = 0.0
    unless is_free_registraion?
      categories = Registration::CATEGORIES.collect {|x| x[:name] }
      if categories.include?(self.category)
        amount  = Registration::CATEGORIES.select {|x| x[:name] == self.category}.first[:price]
      end
    end
    amount
  end

  def transliterate_file_name
    extension = File.extname(attachment.original_filename).gsub(/^\.+/, '')
    filename = attachment.original_filename.gsub(/\.#{extension}$/, '')
    self.attachment.instance_write(:file_name, "#{transliterate(filename)}.#{transliterate(extension)}")
  end

  def transliterate(str)
    s = Iconv.iconv('ascii//ignore//translit', 'utf-8', str).to_s
    s.downcase!
    s.gsub!(/'/, '')
    s.gsub!(/[^A-Za-z0-9]+/, ' ')
    s.strip!
    s.gsub!(/\ +/, '-')
    return s
  end

  def check_if_terms_accepted
    unless terms_accepted?
      self.errors.add(:terms_accepted, "You must agree to the terms and conditions.")
    end
  end

  def full_name(scope = nil)
    if scope == 'reverse'
      "#{last_name.capitalize}, #{first_name.capitalize} #{middle_name.present? ? "#{middle_name.first.capitalize}." : nil}".squish
    elsif scope == 'display'
      puts 'Im on display'
      name = []
      [:first_name, :middle_name, :last_name].each do |attr|
        if send(attr).present?
          if attr == :middle_name
            name << "#{send(attr)[0]}."
          else
            name << send(attr)
          end
        end
      end
      name.join(' ').gsub(/\b\w/){$&.upcase}
    else
      [first_name, middle_name, last_name].select(&:present?).join(' ').gsub(/\b\w/){$&.upcase}
    end
  end

  def display_name
    full_name('reverse')
  end

  def paid_online
    !admin_encoded?
  end

  def notify_admins
    RegistrationMailer.notify_admins(self).deliver_now
  end

  def approve
    self.approved = true
    self.approved_at = Time.zone.now
    self.status = 'approved'
  end

  def reviewed?
    approved? || rejected?
  end

  def reject(user = nil)
    self.rejected = true
    self.status = 'rejected'
    rejected_reg = self.build_rejected_registration
    rejected_reg.rejected_by = user.id if user.present?
    rejected_reg.rejected_at = Time.now
  end

  def rejected_by_user
    if self.rejected_registration.present? && self.rejected_registration.disapprover.present?
      return self.rejected_registration.disapprover
    end
    nil
  end

  private

  def sanitize_string_fields
    ["first_name", "last_name", "middle_name", "email"].each do |attr|
      val = send(attr)
      val = val.squish
      if !val.blank? && attr != 'email'
        val = val.capitalize
      end
      write_attribute(attr, val)
    end
  end
end
