class CreateConsumerTypes < ActiveRecord::Migration
  def self.up
    create_table :consumer_types do |t|
      t.string      :name
      t.string      :code
      t.integer     :created_by
      t.integer     :last_updated_by
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :consumer_types
  end
end
