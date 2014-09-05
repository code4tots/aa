class Student
  def initialize first_name, last_name
    @first_name = first_name.strip
    @last_name = last_name.strip
    @courses = []
  end
  
  attr_reader :courses
  
  def name
    @first_name + ' ' + @last_name
  end
  
  def enroll course
    @courses.each do |old_course|
      if old_course.conflicts_with?(course)
        raise "#{old_course.name} conflicts with #{course.name}"
      end
    end
    @courses << course unless @courses.include?(course)
  end
  
  def course_load
    h = {}
    h.default = 0
    @courses.each do |course|
      h[course.department] += course.credits
    end
    h
  end
end

class Course
  def initialize name, department, credits, options={}
    defaults = {
      :days_of_week => [],
      :time_block => 0
    }
    options = defaults.merge(options)
    @name = name
    @department = department
    @credits = credits
    @students = []
    @days_of_week = options[:days_of_week]
    @time_block = options[:time_block]
  end
  
  attr_reader(
    :department, :credits, :name, :students, :days_of_week, :time_block)
  
  def conflicts_with? course
    @days_of_week.each do |day1|
      course.days_of_week.each do |day2|
        if day1 == day2 && @time_block == course.time_block
          return true
        end
      end
    end
    false
  end
  
  def add_student student
    @students << student unless @students.include?(student)
    student.enroll(self)
  end
end



# s = Student.new 'first', 'last'
# c1 = Course.new 'c1', 'd1', 10, :days_of_week => [:monday, :wednesday]
# c2 = Course.new 'c2', 'd1', 10, :days_of_week => [:monday, :tuesday]
# p c1.conflicts_with?(c2)
#
# c1.add_student(s)
# c2.add_student(s)
