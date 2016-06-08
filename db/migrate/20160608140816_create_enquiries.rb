class CreateEnquiries < ActiveRecord::Migration
  def self.up
    create_table :enquiries do |t|
      t.string        :name
      t.string        :email
      t.text          :message
      t.string        :ip_address
      t.datetime      :sent_at
      t.boolean       :is_active, default: true
      t.timestamps
    end
  end

  def self.down
    drop_table :enquiries
  end
end
