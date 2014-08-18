# fills the database with sample data
User.create!(user_name: 'user 1')
User.create!(user_name: 'user 2')
Poll.create!(title: 'title', author_id: 1)
Question.create!(poll_id: 1, text: 'question 1 body')
AnswerChoice.create!(question_id: 1, text: 'answer choice 1 to question 1') 
AnswerChoice.create!(question_id: 1, text: 'answer choice 2 to question 1')
Response.create!(user_id: 2, answer_choice_id: 1)

