class AddRemarksToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :remarks,  :text
  end
end
