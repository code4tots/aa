class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :shortened_url_id
      t.integer :user_id
      t.timestamps
    end
    
    add_index :visits, :shortened_url_id
    add_index :visits, :user_id
    
    # For counting how many times user has visited a url
    add_index :visits, [:shortened_url_id, :user_id]
  end
end
