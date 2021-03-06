class Registration < ActiveRecord::Base

  CATEGORIES = [
    {name: '3K', price: 250},
    {name: '5K', price: 300},
    {name: '10K', price: 450},
    {name: '21K', price: 700}
  ]
  SINGLET = %w(XS SM MD LG XL XXL)
  STATUS = %w(Approved Pending Rejected Free Online)
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
  has_one :result
  accepts_nested_attributes_for :result

  # STATUS.each do |s|
  #   scope s.downcase.to_sym, -> { where(status: s.downcase) }
  # end
  scope :active, -> {where(active: true)}
  scope :approved, -> {where(status: 'approved')}
  scope :rejected, -> {where(status: 'rejected')}
  scope :pending, -> {where(status: 'pending')}
  scope :free, -> {where(is_free_registraion: true)}
  scope :online, -> {where(admin_encoded: false)}
  scope :male, -> {where(gender: 'Male')}
  scope :female, -> {where(gender: 'Female')}
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
  REPORT_HEADERS = [
    'Registration No.',
    'Category',
    'Singlet',
    'Last Name',
    'First Name',
    'Middle Name',
    'Email',
    'Occupation',
    'Group/Organization/Company',
    'Address',
    'Age',
    'Age on Race Day',
    'Gender',
    'Birth Date',
    'Contact No.',
    'Emergency Contact Name',
    'Emergency Contact Number',
    'Paid On-Site',
    'Bank Name',
    'Date Registered',
    'Approved By',
    'Approved At',
    'Free',
    'Amount',
    'Remarks'
  ]

  class << self

    def display_attributes
      %w{registration_no display_name category singlet gender status date_registered}
    end

    def result_attributes
      %w{registration_no display_name category gender grp_org_comp time_finished}
    end

    def categories
      CATEGORIES.collect {|reg| [ "#{reg[:name]} (P#{reg[:price]})", reg[:name] ]  }
    end

    def category_names
      CATEGORIES.collect {|reg| reg[:name] }
    end

    def category_price(name)
      CATEGORIES.select {|cat| cat[:name] == name}[0][:price] rescue 0
    end

    def details_attributes
      ["registration_no", "category", "singlet", "email", "last_name", "first_name", "middle_name", "gender", "date_registered", "birth_date", "age", "age_on_race_day", "occupation", "grp_org_comp", "residential_address", "contact_numbers", "emergency_contact_name", "emergency_contact_number"]
    end

    def human_attribute_name(attr, options={})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    def fetch_by_category(category)
      where("LOWER(category) = ?", category.strip.downcase)
    end

    def total
      sum(:amount)
    end

    def build_overview_row(cat, ctr)
      #['Category', 'Registration Fee', 'Male Participants', 'Female Participants', 'Total Participants', 'Free', 'Gross Amount', 'Less: Free Registration', 'Total Registration Amount']
      # sheet.add_row ['Male Participants', registrations.male.size], style: info_style
      # sheet.add_row ['Female Participants', registrations.female.size], style: info_style
      # sheet.add_row ['Total Participants', "=B#{info_ctr} + B#{info_ctr + 1}"], style: info_style
      # sheet.add_row ['Free Participants', registrations.free.size], style: info_style
      # sheet.add_row [nil, nil], style: info_style
      # sheet.add_row ['Registration Fee', Registration.category_price(cat)], style: info_style
      # sheet.add_row ['Gross Amount', "=B#{info_ctr + 2} * B#{info_ctr + 5}"], style: info_style
      # sheet.add_row ['Less: Free Registration', "=B#{info_ctr + 3} * B#{info_ctr + 5}"], style: wb.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, fg_color: "D25C51")
      # sheet.add_row ['Total Registration Amount', "=B#{info_ctr + 6} - B#{info_ctr + 7}"], style: wb.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, b: true)
      row = []
      row << cat
      row << category_price(cat)
      row << male.size
      row << female.size
      row << "=C#{ctr} + D#{ctr}"
      row << free.size
      row << "=E#{ctr} * B#{ctr}"
      row << "=F#{ctr} * B#{ctr} * -1"
      row << "=G#{ctr} + H#{ctr}"
      row
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
      "#{last_name.titleize}, #{first_name.titleize} #{middle_name.present? ? "#{middle_name.first.capitalize}." : nil}".squish
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
      name.join(' ').gsub(/\b\w/){$&.titleize}
    else
      [first_name, middle_name, last_name].select(&:present?).join(' ').gsub(/\b\w/){$&.titleize}
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

  def build_xlsx_row(ctr)
    row = []
    row << self.registration_no # 'Registration No.'
    row << self.category # 'Category'
    row << self.singlet # 'Singlet'
    row << self.last_name # 'Last Name'
    row << self.first_name # 'First Name'
    row << self.middle_name # 'Middle Name'
    row << self.email # 'Email'
    row << self.occupation # 'Occupation'
    row << self.grp_org_comp # 'Group/Organization/Company'
    row << self.residential_address # 'Address'
    row << self.age # 'Age'
    row << self.age_on_race_day # 'Age on Race Day'
    row << self.gender # 'Gender'
    row << self.birth_date # 'Birth Date'
    row << self.contact_numbers # 'Contact No.'
    row << self.emergency_contact_name # 'Emergency Contact Name'
    row << self.emergency_contact_number # 'Emergency Contact Number'
    row << (self.admin_encoded? ? 'No' : 'Yes') # 'Paid On-Site'
    row << self.bank_name # 'Bank Name'
    row << self.date_registered # 'Date Registered'
    row << self.approver.try(:full_name) # 'Approved By'
    row << (self.approved_at.present? ? self.approved_at.to_date : nil) # 'Approved At'
    row << (self.is_free_registraion? ? 'Yes' : 'No') # 'Free'
    row << self.amount # 'Amount'
    row << self.remarks # 'Remarks'
    row
  end

  def time_finished
    result.present? ? result.pretty_duration : '--:--:--'
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
