class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :album_id, null: false
      t.string :name, null: false
      t.boolean :bonus, null: false
      t.index :album_id
      t.index :name
      t.timestamps
    end
  end
end
