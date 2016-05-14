class CreateRegistrations < ActiveRecord::Migration
  def up
    create_table :registrations do |t|
      t.string :registration_no
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :occupation
      t.string :grp_org_comp
      t.text :residential_address
      t.integer :age
      t.string :gender
      t.date   :birth_date
      t.string :contact_numbers
      t.string :emergency_contact_name
      t.string :emergency_contact_number
      t.boolean :receive_newsletters, default: false
      t.boolean :terms_accepted, default: false
      t.datetime :terms_accepted_by
      t.integer :age_on_race_day
      t.boolean :paid_online, default: false
      t.boolean :approved, default: false
      t.datetime :approved_at
      t.integer :approved_by
      t.string  :category
      t.string  :singlet
      t.boolean :confirmation_sent, default: false
      t.datetime :confirmation_sent_at
      t.attachment :attachment


      t.timestamps null: false
    end
  end

  def down
    drop_table :registrations
  end
end
