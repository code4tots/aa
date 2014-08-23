class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.integer :user_id, presence: true
      t.index :user_id
      t.index [:user_id, :email], unique: true
      t.timestamps
    end
  
    reversible do |dir|
      dir.up do
        # execute <<-SQL
        # SQL
      end
      
      dir.down do
        # execute <<-SQL
        #
        # SQL
      end
    end
  end
end
