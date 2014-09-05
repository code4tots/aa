class Track < ActiveRecord::Base
  validates :album_id, :name, presence: true
  belongs_to :album
  delegate :band, to: :album
end
