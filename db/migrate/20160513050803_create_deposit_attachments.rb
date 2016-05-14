class CreateDepositAttachments < ActiveRecord::Migration
  def change
    create_table :deposit_attachments do |t|
      t.belongs_to   :registration
      t.attachment   :attachment

      t.timestamps null: false
    end
  end
end
