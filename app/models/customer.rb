class Customer < ActiveRecord::Base
  include Responsible

  validates :first_name, :last_name, :mi, :consumer_type_id, presence: true
  validates_date :date_connected, on_or_before: lambda { Date.current }, allow_blank: true
  before_save :sanitize_string_fields


  class << self

    def display_attributes
      %w{full_name account_no zone created_at}
    end
  end

  def full_name(reverse = true)
    if reverse
      "#{last_name}, #{first_name} #{mi}."
    else
      [first_name, mi, last_name].select(&:present?).join(' ').gsub(/\b\w/){$&.upcase}
    end
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

end
