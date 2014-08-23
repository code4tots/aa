class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, unique: true, presence: true
      t.index :username
      t.timestamps
    end
  end
end
