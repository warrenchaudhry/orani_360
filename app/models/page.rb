class Page < ActiveRecord::Base
  include Responsible
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_many :pages, dependent: :destroy
  # has_many :page_banners, :dependent => :destroy
  # has_many :banners, :through => :page_banners
  belongs_to  :user, class_name: 'User', foreign_key: :last_updated_by
  before_save :build_meta, :assign_default
  validates :title, presence: true
  validates_uniqueness_of :title
  validates_numericality_of :display_order
  validates_date :publish_date, on_or_before: lambda { Date.current }, allow_blank: true
  default_scope -> { where("page_type = ?", 'page') }
  scope :root, -> {where(is_root: true)}
  scope :contact, -> {where(is_contact: true)}
  scope :sections, -> {where(show_in_menu: true, page_id: nil, active: true, is_contact: false).limit(8).order('display_order ASC')}
  #scope :sub_pages, -> {where('show_in_menu IS true AND (page_id IS NOT NULL ? OR page_id <> "") AND activate IS true').includes(:pages)}
  scope :active, -> {where(active: true)}
  scope :in_menu, -> {where(show_in_menu: true).order('display_order ASC')}

  class << self

    def display_attributes
      %w{title editor active updated_at}
    end

    def find(input)
      input.to_i == 0 ? find_by_slug(input) : super
    end

  end

  def build_meta
    if self.meta_title.blank?
      self.meta_title = self.title
    end
  end

  def has_child?
    self.pages.any?
  end

  def has_parent?
    unless self.page_id.blank?
      return true
    end
    false
  end

  def parent
    if self.has_parent?
      parent= get_parent(self.page_id)
    end
    parent
  end

  def ancestors
    @ancestors = []
    if self.has_parent?
      get_ancestors(self.page_id)
    end
    @ancestors.reverse
  end

  def collected_ancestors
    @ancestors
  end

  def get_ancestors(page_id)
    parent = Page.find(page_id)
    unless parent.nil?
      collected_ancestors << parent
      if parent.has_parent?
        get_ancestors(parent.page_id)
      end
    end
    @ancestors
  end

  def get_parent(page_id)
    parent = Page.find(page_id)
    parent
  end

  def sanitize_string_fields
    ["account_no", "last_name", "first_name", "mi", "zone", "street", "barangay"].each do |attr|
      val = send(attr)
      val = val.squish
      unless val.blank?
        val = val.capitalize
      end
      write_attribute(attr, val)
    end
  end

  def assign_default

  end

end
