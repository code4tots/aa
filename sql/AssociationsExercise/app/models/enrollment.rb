class Enrollment < ActiveRecord::Base
  # belongs_to(:user, :class_name => 'User')
  
  # From looking at the enrollment object from the rails console,
  # it looks like in spite of the instructions specifying `Enrollment.first.user`,
  # the correct syntax probably should be `Enrollment.first.student`.
  
  belongs_to(:user,
    foreign_key: :student_id,     # name of the foreign_key column on User
    class_name: 'User')
  
  belongs_to(:course,
    class_name: 'Course')
end
