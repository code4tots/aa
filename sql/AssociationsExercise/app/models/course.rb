class Course < ActiveRecord::Base
  has_many(:enrollments)
  
  has_many(:enrolled_students,
    source: :course,              # The association in enrollments used to
                                  # connect to this course.
    through: :enrollments)
end
