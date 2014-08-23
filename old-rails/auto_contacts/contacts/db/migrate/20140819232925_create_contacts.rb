class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email, uniqueness: true
      t.integer :user_id, null: false, uniqueness: true
    end
    
    add_index :contacts, :user_id
  end
end
