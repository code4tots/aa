class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :user_name, :null => false, :unique => true
      t.timestamps
    end
    
    add_index :users, :user_name, :unique => true
  end
end
