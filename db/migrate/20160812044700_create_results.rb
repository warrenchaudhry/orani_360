class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer     :registration_id
      t.text        :remarks
      t.string      :category, index: true
      t.integer     :time_finished
      t.string      :gender, index: true
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :results
  end
end
