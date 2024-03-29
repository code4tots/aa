# == Schema Information
#
# Table name: goals
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string(255)      not null
#  access      :string(255)      not null
#  description :text             not null
#  status      :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Goal < ActiveRecord::Base
  include Commentable
  
  ACCESSES = %w(public private)
  STATUSES = %w(pending completed)
  
  validates :user_id, :name, :access, :description, :status, presence: true
  validates :access, inclusion: ACCESSES
  validates :status, inclusion: STATUSES
  
  belongs_to :user
  
  after_initialize do |goal|
    goal.access ||= 'public'
    goal.status ||= 'pending'
    goal.name ||= 'goal name here'
    goal.description ||= 'goal description here'
  end
  
  def is_viewable_by?(user)
    return true if access == 'public'
    return false if user.nil?
    self.user.id == user.id
  end
end
