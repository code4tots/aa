class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true
  validates :password_digest, presence: true, uniqueness: true
  validates :session_token, presence: true, uniqueness: true
  
  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end
  
  after_initialize do |user|
    user.session_token = self.class.generate_session_token if user.session_token.nil?
  end
  
  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
  end
  
  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end
end
