class ConsumerType < ActiveRecord::Base
  has_many :customers
  validates :name, :code, presence: true
  before_save :sanitize_string_fields

  class << self

    def display_attributes
      %w{name code created_at}
    end
  end

  def sanitize_string_fields
    ["name", "code"].each do |attr|
      val = send(attr)
      val = val.squish
      unless val.blank?
        if attr == 'code'
          val = val.upcase
        else
          val = val.capitalize
        end
      end
      write_attribute(attr, val)
    end
  end
end
