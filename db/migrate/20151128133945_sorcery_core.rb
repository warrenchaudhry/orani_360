class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,            :null => false
      t.string :email,            :null => false
      t.string :crypted_password
      t.string :salt

      t.string :first_name
      t.string :mi
      t.string :last_name
      t.string :suffix
      t.date   :birthdate
      t.integer :age
      t.string :gender


      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
