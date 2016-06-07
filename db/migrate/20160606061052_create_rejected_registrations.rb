class CreateRejectedRegistrations < ActiveRecord::Migration
  def change
    create_table :rejected_registrations do |t|
      t.integer :registration_id
      t.text :reason
      t.integer :rejected_by
      t.datetime :rejected_at
      t.boolean :sent, default: false
      t.datetime  :sent_at

      t.timestamps null: false
    end
  end
end
