class Visit < ActiveRecord::Base
  validates :shortened_url_id, presence: true
  validates :user_id, presence: true
  
  belongs_to(:url,
    foreign_key: :shortened_url_id,
    class_name: 'ShortenedUrl')
    
  belongs_to(:visitor,
    foreign_key: :user_id,
    class_name: 'User')
  
  def self.record_visit!(user, shortened_url)
    create!(shortened_url_id: shortened_url.id, user_id: user.id)
  end
end
