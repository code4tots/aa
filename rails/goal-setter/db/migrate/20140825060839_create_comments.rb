class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, null: false
      t.references :user, null: false
      t.text :content, null: false
      t.index :user_id
      t.index [:commentable_id, :commentable_type]
      t.timestamps
    end
  end
end
