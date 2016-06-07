class AddColumnsToRegistrations < ActiveRecord::Migration
  def change
    add_column    :registrations,     :rejected,      :boolean,     default: false
    add_column    :registrations,     :status,        :string,  index: true
    add_index     :registrations,     :registration_no
    add_index     :registrations,     :first_name
    add_index     :registrations,     :last_name

    registrations = Registration.all
    registrations.each do |reg|
      if reg.approved?
        reg.status = 'approved'
      else
        reg.status = 'pending'
      end
      reg.save(validate: false)
    end
  end

  def self.down

  end
end
