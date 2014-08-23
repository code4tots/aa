class User < ActiveRecord::Base
  has_many(:contacts,
    foreign_key: :user_id,
    class_name: :Contact)
end
