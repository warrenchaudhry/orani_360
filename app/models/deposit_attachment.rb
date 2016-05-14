class DepositAttachment < ActiveRecord::Base
  belongs_to :registration
  has_attached_file :attachment, :styles => {
      :large => "1400x550>",
      :medium => "960x300>",
      :thumb => "120x120>"
  },
  :url  => "/payment_attachments/:id/:style/:basename.:extension",
  :path => "/payment_attachments/:id/:style/:basename.:extension",
  :default_url => "/assets/no-image.png",
  :default_style => :medium
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  validates_attachment_presence :attachment
  before_post_process :transliterate_file_name

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
end
