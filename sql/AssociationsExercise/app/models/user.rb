class User < ActiveRecord::Base
  has_many(:enrollments,
    foreign_key: :student_id,  # The name of the column in enrollments 
                               # that point to this user.
    class_name: 'Enrollment')
  
  has_many(:enrolled_courses,
    source: :user,            # The association in enrollments used to 
                              # connect to users
    class_name: 'Course',
    through: :enrollments)
end
