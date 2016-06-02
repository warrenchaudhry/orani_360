class AddAdminEncodedToRegistrations < ActiveRecord::Migration
  def change
    add_column      :registrations,       :admin_encoded,       :boolean,   default: false
    add_column      :registrations,       :is_paid_on_site,     :boolean,   default: false
    add_column      :registrations,       :active,              :boolean,   default: true
    add_column      :registrations,       :bank_name,           :string
    add_column      :registrations,       :date_registered,     :date
    add_column      :registrations,       :is_free_registraion, :boolean,   default: false
    add_column      :registrations,       :discount,            :decimal,   precision: 8, scale: 2, default: 0.00
    add_column      :registrations,       :amount,              :decimal,   precision: 8, scale: 2, default: 0.00
    rename_column   :registrations,       :terms_accepted_by,   :terms_accepted_at

  end
end
