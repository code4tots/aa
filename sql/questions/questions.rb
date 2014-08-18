require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    
    # I imagine less efficient, but more convenient to recieve rows as
    # hashes instead of array of values.
    self.results_as_hash = true
    
    # Convert types to their appropriate values instead of just returning
    # as strings
    self.type_translation = true
  end
end

class TableObject
  # Try to stay DRY.
  # The field names should be deduced from the database itself.
  def self.initialize_from_database
    query = "PRAGMA table_info(#{table_name})"
    @attrs = []
    QuestionsDatabase.instance.execute(query).each do |row|
      attr_accessor (@attrs << row['name'])[-1]
    end
  end
  
  def self.find_by_query(query)
    QuestionsDatabase.instance.execute(query).map do |row|
      self.new(row)
    end
  end
  
  def self.find_unique_by_query(query)
    results = find_by_query(query)
    raise "#{query} not found" if results.size == 0
    raise "#{query} is not unique" if results.size > 1
    results[0]
  end
  
  def self.all
    find_by_query("SELECT * FROM #{table_name}")
  end
  
  def initialize(row={})
    row.each do |key, value|
      self.send(key.to_s+'=', value)
    end
  end
  
  def save
    id_name = self.class.id_name
    attrs = self.class.instance_variable_get("@attrs")
    
    if send(id_name).nil?
      cols = attrs.join(', ')
      vals = attrs.map { |a| "'#{send(a)}'" }.join(', ')
      
      QuestionsDatabase.instance.execute(<<-SQL)
      INSERT INTO #{self.class.table_name} (#{cols})
      VALUES      #{vals}
      SQL
    else
      
      vals = attrs.reject do |a|
        a == id_name
      end.map do |a|
        "#{a} = '#{send(a)}'"
      end.join(', ')
      
      QuestionsDatabase.instance.execute(<<-SQL)
      UPDATE #{self.class.table_name}
      SET    #{vals}
      WHERE  #{id_name} = #{send(id_name)}
      SQL
    end
  end
end

# I couldn't find documentation on dynamically setting global constants.
# There are ways to set constants on specific modules, but the method
# dosen't seem to work on the global 'main' object.
names = []
User,
Question,
QuestionFollower,
Reply,
QuestionLike = clss = [
  ['User', 'users'],
  ['Question', 'questions'],
  ['QuestionFollower', 'question_followers'],
  ['Reply', 'replies'],
  ['QuestionLike', 'question_likes']
].map do |name, table_name|
  names << name
  
  cls = Class.new(TableObject)
  
  cls.define_singleton_method('table_name') do
    table_name
  end
  
  cls.define_singleton_method('singular_name') do
    name.gsub(/([A-Z])/, '_\1').downcase[1..-1]
  end
  
  cls.define_singleton_method('plural_name') do
    table_name
  end
  
  cls.define_singleton_method('id_name') do
    # Precede all non-first capital letters with
    # an underscore.
    
    singular_name + '_id'
  end
  
  cls.define_singleton_method('name') do
    name
  end
  
  cls.initialize_from_database
  
  cls
end

#################################################
# Some (very dirty) monkey patching
################################################

clss.each do |cls1|
  clss.each do |cls2|
    
    #################################################################
    # First task is to add methods of the form
    #       
    #       cls1::find_by_(cls2)_id
    #
    #################################################################
    
    # Names of class methods to add to cls1
    class_method_names = []
    
    class_method_names << 'find_by_id'                if cls1 == cls2
    class_method_names << 'find_by_' + cls2.id_name
    class_method_names << 'find_by_author_id'         if cls2 == User
    
    # We want a unique value iff cls1 == cls2
    
    query_type =
      cls1 == cls2 ? 
        :find_unique_by_query :
        :find_by_query
    
    # Define methods that will return the elements of cls1
    # that match given an id for cls2.
    
    class_method_names.each do |method_name|
      cls1.define_singleton_method(method_name) do |id|
        cls1.send(query_type,<<-SQL)
        SELECT *
        FROM   #{cls1.table_name}
        WHERE  #{cls2.id_name} = #{id}
        SQL
      end
    end
    
    #################################################################
    # Next task is to do the converse:
    # add methods of the form
    #       
    #       cls1#(cls2)   (singular)
    #
    # Where we look up cls1#(cls2)_id to determine what to return
    #################################################################
    
    method_names = []
    method_names << 'author' if cls2 == User
    method_names << cls2.singular_name
    
    method_names.each do |method_name|
      cls1.class_eval do
        define_method(method_name) do
          # get id in cls1 instance that is foreign key mapped to cls2.
          id = self.send(cls2.id_name)
          cls2.find_by_id(id)
        end
      end
    end
    
    #################################################################
    # Next task is similar to above, but plural:
    # add methods of the form
    #       
    #       cls1#(cls2)   (plural)
    #
    # Where we look up (cls1)_id to determine what to return
    # Returns all elements of type cls2, associated with cls1.
    #################################################################
    
    method_names = []
    method_names << 'authors' if cls2 == User
    method_names << cls2.plural_name
    
    method_names.each do |method_name|
      cls1.class_eval do
        define_method(method_name) do
          # get primary id associated with cls1 instance
          id = self.send(cls1.id_name)
          
          # Find all instances of cls2 instance whose cls1 foreign key
          # is equal to id.
          cls2.send('find_by_'+cls1.id_name, id)
        end
      end
    end
  end
end


########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
# Monkey patch for things I didn't generalize
# 
# At some point I realized, I'm pretty sure some library already does
# these generalizations I'm thinking of. At least for now, I might
# as well just get these done.
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################

class User
  def self.find_by_name(fname, lname)
    find_by_query <<-SQL
    SELECT *
    FROM   #{table_name}
    WHERE  fname='#{fname}'
    AND    lname='#{lname}'
    SQL
  end
  
  # Names are similar, but not exactly like my generalized methods
  alias_method :authored_questions, :questions
  alias_method :authored_replies, :replies
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(user_id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(user_id)
  end
  
  def average_karma
    QuestionsDatabase.instance.execute(<<-SQL)[0]['x']
    SELECT
      CAST(COUNT(ql.question_like_id) AS FLOAT) /
      COUNT(DISTINCT(q.question_id))
      x
    FROM              #{Question.table_name} q
    LEFT OUTER JOIN   #{QuestionLike.table_name} ql
    ON                q.question_id = ql.question_id
    SQL
  end
end

class Question
  def followers
    QuestionFollower.followers_for_question_id(question_id)
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
  
  def likers
    QuestionLike.likers_for_question_id(question_id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(question_id)
  end
  
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
end

class QuestionFollower
  def self.followers_for_question_id(question_id)
    User.find_by_query <<-SQL
    SELECT u.*
    FROM   #{User.table_name} u
    JOIN   #{QuestionFollower.table_name} q
    ON     u.user_id = q.user_id
    WHERE  q.question_id = #{question_id}
    SQL
  end
  
  def self.followed_questions_for_user_id(user_id)
    Question.find_by_query <<-SQL
    SELECT q.*
    FROM   #{Question.table_name} q
    JOIN   #{QuestionFollower.table_name} f
    ON     q.question_id = f.question_id
    WHERE  f.user_id = #{user_id}
    SQL
  end
  
  def self.most_followed_questions(n)
    # We use a left outer join, so that even questions with zero
    # followers may be listed if n is large enough.
    Question.find_by_query <<-SQL
    SELECT           q.*
    FROM             #{Question.table_name} q
    LEFT OUTER JOIN  #{table_name} f
    ON               q.question_id = f.question_id
    GROUP BY         question_id
    ORDER BY         COUNT(f.user_id) DESC
    LIMIT            #{n}
    SQL
  end
end

class Reply
  def parent_reply
    Reply.find_by_id(parent_id)
  end
  
  def child_replies
    Reply.find_by_query <<-SQL
    SELECT  *
    FROM    #{Reply.table_name}
    WHERE   parent_id = '#{reply_id}'
    SQL
  end
end

class QuestionLike
  def self.likers_for_question_id(question_id)
    User.find_by_query <<-SQL
    SELECT  u.*
    FROM    #{table_name} ql
    JOIN    #{User.table_name} u
    ON      ql.user_id = u.user_id
    WHERE   ql.question_id = #{question_id}
    SQL
  end
  
  def self.num_likes_for_question_id(question_id)
    QuestionsDatabase.instance.execute(<<-SQL)[0]['x']
    SELECT    COUNT(user_id) x
    FROM      #{table_name} ql
    GROUP BY  question_id
    HAVING    question_id = #{question_id}
    SQL
  end
  
  def self.liked_questions_for_user_id(user_id)
    Question.find_by_query <<-SQL
    SELECT  q.*
    FROM    #{table_name} ql
    JOIN    #{Question.table_name} q
    ON      ql.question_id = q.question_id
    WHERE   ql.user_id = #{user_id}
    SQL
  end
  
  def self.most_liked_questions(n)
    # Pretty much identical to QuestionFollower::most_followed_questions
    Question.find_by_query <<-SQL
    SELECT           q.*
    FROM             #{Question.table_name} q
    LEFT OUTER JOIN  #{table_name} ql
    ON               ql.question_id = q.question_id
    GROUP BY         question_id
    ORDER BY         COUNT(ql.user_id) DESC
    LIMIT            #{n}
    SQL
  end
end

user1 = User.find_by_id(1)
question1 = Question.find_by_id(1)
question_follower1 = QuestionFollower.find_by_id(1)
reply1 = Reply.find_by_id(1)
reply2 = Reply.find_by_id(2)
question_like1 = QuestionLike.find_by_id(1)

# Tests ----

# ------------------------ EASY ----------------------------

# p User.find_by_name('B','2')
# p user1.authored_questions
# p user1.authored_replies
# p Question.find_by_author_id(1)
# p question1.author
# p question1.replies
# p Reply.find_by_question_id(1)
# p Reply.find_by_user_id(1)
# p reply2.author
# p reply2.question
# p reply2.parent_reply
# p reply1.child_replies

# ------------------------ MEDIUM ----------------------------

# p QuestionFollower.followers_for_question_id(1)
# p QuestionFollower.followed_questions_for_user_id(1)
# p user1.followed_questions
# p question1.followers

# ------------------------ HARD ----------------------------

# p QuestionFollower.most_followed_questions(10)
# p Question.most_followed(10)
#
# p QuestionLike.likers_for_question_id(1)
# p QuestionLike.num_likes_for_question_id(1)
# p QuestionLike.liked_questions_for_user_id(1)
# p question1.likers
# p question1.num_likes
# p user1.liked_questions
# p QuestionLike.most_liked_questions(1)
# p Question.most_liked(2)
# p user1.average_karma
# p User.find_by_user_id(3).average_karma

<<-TEST
clear && rm questions.db && cat import_db.sql | sqlite3 questions.db && ruby questions.rb
TEST

#### Modification works as desired!!!
#### 
#### WARNING!!!! If you use above line to test, it will clear
#### Any changes made between sessions. To see the difference,
#### Just run
####
####      ruby questions.rb
####
#### And it will work as expected.
####

# user1.fname = 'first name'
# user1.save

p User.all
