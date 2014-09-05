class AnswerChoice < ActiveRecord::Base
  validates :question_id, presence: true
  validates :text, presence: true
  
  belongs_to(:question,
    foreign_key: :question_id,
    class_name: :Question)
    
  has_many(:responses,
    foreign_key: :answer_choice_id,
    class_name: :Response)
end
