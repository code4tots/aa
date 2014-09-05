class Contact < ActiveRecord::Base
  validates :name,
    presence: true,
    uniqueness: {
      scope: :user_id
    } 
    
  validates :email,
    presence: true,
    uniqueness: {
      scope: :user_id
    }
    
  validates :user_id, presence: true
  
  belongs_to(:user,
    foreign_key: :user_id,
    class_name: :User)
  
  
end

