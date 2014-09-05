class Question < ActiveRecord::Base
  validates :poll_id, presence: true
  validates :text, presence: true
  
  has_many(:answer_choices,
    foreign_key: :question_id,
    class_name: :AnswerChoice)
    
  belongs_to(:poll,
    foreign_key: :poll_id,
    class_name: :Poll)
    
  has_many(:responses,
    through: :answer_choices,
    foreign_key: :question_id,
    class_name: :Response)
    
  def title
    self[:title]
  end
  
  # Poll results.
  def results
    # # Raw SQL version
    # result = ActiveRecord::Base.connection.execute(<<-SQL)
    # SELECT ac.text choice, COUNT(responses.user_id) count
    # FROM (
    #   SELECT *
    #   FROM   answer_choices
    #   WHERE  answer_choices.question_id = #{id}) ac
    # LEFT OUTER JOIN responses
    # ON responses.answer_choice_id = ac.id
    # GROUP BY ac.id
    # SQL
    #
    # Hash[result.map { |choice| [choice['choice'], choice['count']] } ]
    
    ##########################################
    # STUPID MISTAKE HAPPENED HERE ....
    # if you use an OUTER JOIN you MAY NOT 
    # move the "ON" clause to the
    # "WHERE" clause.
    ##########################################
    Hash[answer_choices.
      joins('LEFT OUTER JOIN responses
      ON
      responses.answer_choice_id = answer_choices.id').
      group('answer_choices.id').
      pluck('answer_choices.text, COUNT(responses.user_id)')]
  end
end
