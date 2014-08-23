class Album < ActiveRecord::Base
  validates :band_id, presence: true, uniqueness: true
  validates :name, presence: true
  belongs_to :band
  has_many :tracks, dependent: :destroy
end
