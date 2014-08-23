class User < ActiveRecord::Base
  validates :email, :session_token, uniqueness: true, presence: true
  validates :password_digest, presence: true
  
  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end
  
  def reset_session_token!
    update!(session_token: self.class.generate_session_token)
  end
  
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
  
  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end
  
  after_initialize do |user|
    user.ensure_session_token
  end
  
  def self.find_by_credentials(email, password)
    user = find_by_email(email)
    return nil if user.nil? || !user.is_password?(password)
    user
  end
end
