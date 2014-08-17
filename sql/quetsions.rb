require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
	include Singleton
	
	def initialize
    super('questions.db')
    
    # less efficient, but more convenient to recieve rows as hases instead
    # of array of values.
    self.results_as_hash = true
    
    # Convert types to their appropriate values instead of just returning
    # as strings
    self.type_translation = true
    
  end
end

class TableObject
  def self.all
    query = "SELECT * FROM #{self.to_s.downcase + 's'}"
    QuestionsDatabase.instance.execute(query).map do |row|
      self.class.new(row)
    end
  end
  
  def initialize(row={})
    row.each do |key, value|
      self.send(key.to_s+'=', value)
    end
  end
end

class User < TableObject
  attr_accessor :user_id, :fname, :lname
end


user = User.new({user_id: 12})
p user

p User.all