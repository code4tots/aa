# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer          not null
#  commentable_type :string(255)      not null
#  user_id          :integer          not null
#  content          :text             not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  validates :commentable, :user, :content, presence: true
  
  belongs_to :commentable, polymorphic: true
  belongs_to :user
end
