class Contact < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: {
    scope: :user_id
  }
  validates :user_id, presence: true
  
  belongs_to(:owner,
    foreign_key: :user_id,
    class_name: :User)
end
