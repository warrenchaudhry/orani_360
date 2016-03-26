class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string          :account_no
      t.string          :last_name
      t.string          :first_name
      t.string          :mi,        limit: 1
      t.string          :zone
      t.string          :street
      t.string          :barangay
      t.string          :municipality
      t.string          :province
      t.integer         :consumer_type_id
      t.date            :date_connected
      t.string          :status, default: 'active'
      t.integer         :created_by
      t.integer         :last_updated_by
      t.timestamps null: false
    end

    add_index :customers, :account_no, unique: true
  end

  def self.down
    drop_table :customers
  end
end
