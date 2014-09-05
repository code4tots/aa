class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :user_id, null: false
      t.index [:email, :user_id], unique: true
      t.index :user_id, unique: true
      t.timestamps
    end
  end
end
