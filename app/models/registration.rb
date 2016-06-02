class Registration < ActiveRecord::Base

  CATEGORIES = [
    {name: '3K', price: 250},
    {name: '5K', price: 300},
    {name: '15K', price: 450},
    {name: '21K', price: 700}
  ]
  SINGLET = %w(XS SM MD LG XL XXL)
  # has_many :deposit_attachments,  dependent: :destroy
  # accepts_nested_attributes_for :deposit_attachments, allow_destroy: true, :reject_if => :all_blank
  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: EMAIL_REGEX
  validates :first_name, :last_name, :gender, :category, :singlet, presence: true
  validates :residential_address, :birth_date, :contact_numbers,
           :emergency_contact_name, :emergency_contact_number, :bank_name, presence: true, unless: 'is_paid_on_site?'
  validates :registration_no, :date_registered, presence: true, if: 'admin_encoded?'
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

  scope :active, -> {where(active: true)}
  validates_attachment_presence :attachment, unless: 'is_paid_on_site?'
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  before_post_process :transliterate_file_name
  before_save :assign_defaults


  def assign_defaults
    self.age = Toolbox.age(birth_date) if birth_date.present?
    self.age_on_race_day = Toolbox.age(birth_date, '2016-08-14'.to_date)
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
      "#{last_name}, #{first_name} #{middle_name.present? ? "#{middle_name.first.capitalize}." : nil}".squish
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
    full_name('display')
  end

  class << self

    def display_attributes
      %w{display_name category gender approved updated_at}
    end

    def categories
      CATEGORIES.collect {|reg| [ "#{reg[:name]} (P#{reg[:price]})", reg[:name] ]  }
    end

  end
end
