class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, null: false, unique: true
      t.string :password_digest, null: false
      t.string :session_token, null: false
      t.index :session_token, unique: true
      t.index :user_name, unique: true
      t.timestamps
    end
  end
end
