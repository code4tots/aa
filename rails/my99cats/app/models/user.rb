class User < ActiveRecord::Base
  validates :user_name, :session_token, uniqueness: true, presence: true
  validates :password_digest, presence: true
  
  after_initialize do |user|
    user.session_token ||= self.class.generate_session_token
  end
  
  def reset_session_token!
    update!(session_token: self.class.generate_session_token)
  end
  
  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)
    return nil if user.nil? || !user.is_password?(password)
    user
  end
  
  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end
end
