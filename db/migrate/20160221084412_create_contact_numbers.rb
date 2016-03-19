class CreateContactNumbers < ActiveRecord::Migration
  def up
    create_table :contact_numbers do |t|
      t.string      :contact_number
      t.string      :contact_type
      t.references  :contactable, polymorphic: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :contact_numbers
  end
end
