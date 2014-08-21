class CreateCatRentalRequests < ActiveRecord::Migration
  def change
    create_table :cat_rental_requests do |t|
      t.integer :cat_id, null: false
      t.date :start_date
      t.date :end_date
      t.string :status
      
      t.index :cat_id
      
      t.timestamps
    end
  end
end
