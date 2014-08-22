class Contact < ActiveRecord::Base
  [:name, :email, :user_id].each do |prop|
    validates prop, presence: true
  end
  
  validates :email, uniqueness: { scope: :user_id }
  
  belongs_to(:owner,
    foreign_key: :user_id,
    class_name: 'User')
  
  has_many(:contact_shares,
    foreign_key: :contact_id,
    class_name: 'ContactShare')
  
  has_many(:shared_users,
    foreign_key: :contact_id,
    through: :contact_shares,
    source: :user,
    class_name: 'User')
end
