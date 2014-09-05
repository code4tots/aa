class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :user
      t.string :name, null: false
      t.string :access, null: false
      t.text :description, null: false
      t.string :status, null: false
      t.index :user_id
      t.index [:user_id, :name]
      t.index [:user_id, :status]
      t.timestamps
    end
  end
end
