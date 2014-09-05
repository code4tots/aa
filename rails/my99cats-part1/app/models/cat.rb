class Cat < ActiveRecord::Base
  COLORS = %w(black white red green blue)
  
  validates :age, presence: true, numericality: { only_integer: true }
  validates :birth_date, presence: true
  validates :color, presence: true, inclusion: COLORS
  validates :name, presence: true
  validates :sex, presence: true, inclusion: %w(M F)
  validates :description, presence: true
  
  has_many :rental_requests, class_name: 'CatRentalRequest', dependent: :destroy
end
