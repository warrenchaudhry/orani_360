class Post < Page
  include ActionView::Helpers
  include ApplicationHelper
  attr_accessor :remove_photo
  #attr_accessible :remove_photo
  has_attached_file :photo, styles: {
      large: '1280x400>',
      medium: '960x300>',
      thumb: '120x50>'
  },
  url: '/post-cover/:id/:style/:basename.:extension',
  path: '/post-cover/:id/:style/:basename.:extension',
  default_url: '/assets/front/no-image.png',
  default_style: :medium
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  before_save :delete_cover_photo, if: ->{ remove_photo == '1' && !photo_updated_at_changed? }
  scope :featured, -> {where(is_featured: true)}
  before_post_process :transliterate_file_name

  def transliterate_file_name
    extension = File.extname(photo.original_filename).gsub(/^\.+/, '')
    filename = photo.original_filename.gsub(/\.#{extension}$/, '')
    self.photo.instance_write(:file_name, "#{transliterate(filename)}.#{transliterate(extension)}")
  end

  def self.default_scope
    where("page_type = ?", 'post')
  end

  def assign_default
    self.page_type = 'post'
  end

  def get_meta_info
    meta_info = {
        title: "Orani Fun Run | #{self.title}",
        description: short_description(self.body, 200),
        url: Rails.application.routes.url_helpers.show_post_url(self.slug)
    }
    if self.photo.present?
      meta_info[:image] = self.photo.url(:thumb)
    end
    meta_info
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

  private
  def delete_cover_photo
    self.photo = nil
  end
end