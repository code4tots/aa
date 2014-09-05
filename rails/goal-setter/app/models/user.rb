# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  include Commentable
  
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  
  has_many :goals, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :made_comments, class_name: :Comment
  
  after_initialize do |user|
    user.session_token ||= self.class.generate_session_token
  end
  
  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    # self.password_digest == BCrypt::Password.create(password)
    ## won't work because BCrypt generates salted digests.
    ## BCrypt::Password.new ... takes care of this.
    BCrypt::Password.new(password_digest).is_password?(password)
  end
  
  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
  end
  
  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    return nil if user.nil?
    return nil unless user.is_password?(password)
    user
  end
end
