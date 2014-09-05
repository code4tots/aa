class CreateContactShares < ActiveRecord::Migration
  def change
    create_table :contact_shares do |t|
      t.integer :contact_id
      t.integer :user_id
      t.index :contact_id
      t.index :user_id
      t.index [:contact_id, :user_id], unique: true
      t.timestamps
    end
  end
end
