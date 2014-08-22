class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, unique: true, presence: true
      t.string :password_digest, presence: true
      t.string :session_token, presence: true, unique: true
      t.index :user_name, unique: true
      t.index :session_token, unique: true
      t.timestamps
    end
  end
end
