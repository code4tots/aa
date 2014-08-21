class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, uniqueness: true
  
end
