class Cat < ActiveRecord::Base
  COLORS = %w(black white red green blue)
  
  validates :name,
    presence: true
  
  validates :age,
  numericality: { only_integer: true }
  
  validates :color,
    inclusion: { in: COLORS }
  
  validates :sex,
    inclusion: { in: ['M', 'F'] }
    
end
