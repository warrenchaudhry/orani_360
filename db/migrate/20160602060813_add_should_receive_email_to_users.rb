class AddShouldReceiveEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :should_receive_email, :boolean, default: false
  end
end
