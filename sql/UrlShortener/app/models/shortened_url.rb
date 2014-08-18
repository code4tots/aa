class ShortenedUrl < ActiveRecord::Base
  validates :long_url, presence: true, uniqueness: true
  validates :short_url, presence: true, uniqueness: true
  validates :submitter_id, presence: true
  
  belongs_to(:submitter,
    foreign_key: :submitter_id,
    class_name: 'User')
  
  def self.random_code
    # According to the docs, urlsafe_base64(n) creates a string
    # of rougly 4/3 * n. So I suppose it is reasonable to let n = 16,
    # and then just cut out the first 16 characters.
    while true
      code = SecureRandom.urlsafe_base64(16)[0...16]
      break unless exists?(short_url: code)
    end
    code
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    su = ShortenedUrl.new
    su.long_url = long_url
    su.short_url = random_code
    su.submitter_id = user.id
    su
  end
end