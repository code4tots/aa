class User < ActiveRecord::Base
  validates :username, uniqueness: true, presence: true
  
  # Contact data associated with this user.
  has_many(:contact_data,
    foreign_key: :user_id,
    class_name: 'Contact')
  
  # Record of each time this user has given out a contact
  has_many(:contact_shares,
    foreign_key: :user_id,
    class_name: 'ContactShare')
  
  # Contacts that other users have given this user.
  has_many(:contacts,
    foreign_key: :user_id,
    through: :contact_shares,
    source: :contact,
    class_name: 'Contact')
end
