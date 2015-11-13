class Response < ActiveRecord::Base
  belongs_to :answer_choice,
    foreign_key: :answer_choice_id,
    primary_key: :id,
    class_name: "AnswerChoice"

  belongs_to :respondent,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "User"

  has_one :question,
    through: :answer_choice,
    source: :question

  validate :respondent_has_not_already_answered_question
  validate :author_doesnt_answer_own_question

  # has_many :sibling_responses,
  #   -> { where 'responses.id != ?', self.id },
  #   through: :question,
  #   source: :responses

  validates :user_id, presence: true
  validates :answer_choice_id, presence: true

  def sibling_responses
    question.responses.where('? is NULL OR responses.id != ?', self.id, self.id)
  end

  private
  def respondent_has_not_already_answered_question
    if self.sibling_responses.exists?(user_id: self.user_id)
      errors[:multiple_responses] << "User has already responded."
    end
  end

  def author_doesnt_answer_own_question
    if self.user_id == self.question.poll.author_id
      errors[:invalid_response] << "Author cannot answer own question"
    end
  end
end
