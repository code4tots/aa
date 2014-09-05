class CreateContactShares < ActiveRecord::Migration
  def change
    create_table :contact_shares do |t|
      t.integer :contact_id, presence: true, null: false
      t.integer :user_id, presence: true, null: false
      t.index [:contact_id, :user_id], unique: true
    end
  end
end
