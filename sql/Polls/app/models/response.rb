class Response < ActiveRecord::Base
  validates :user_id, presence: true
  validates :answer_choice_id, presence: true
  
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_original_poster
  
  belongs_to(:answer_choice,
    foreign_key: :answer_choice_id)
  
  belongs_to(:respondent,
    foreign_key: :user_id,
    class_name: :User)
    
  has_one(:question,
    through: :answer_choice,
    source: :question)
    
  def sibling_responses
    question.responses.where.not(id: id).where.not(id: nil)
  end
  
  def respondent_has_not_already_answered_question
    if sibling_responses.exists?
      errors[:base] << "respondent has already answerwed question!"
    end
  end
  
  def respondent_is_not_original_poster
    if question.poll.author.id == respondent.id
      errors[:base] << "respondent is the original poster!"
    end
  end
end
