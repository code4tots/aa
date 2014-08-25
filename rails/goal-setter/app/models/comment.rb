class Comment < ActiveRecord::Base
  validates :commentable, :user, :content, presence: true
  
  belongs_to :commentable, polymorphic: true
  belongs_to :user
end
