class Response < ActiveRecord::Base

  validate  :respondent_has_not_already_answered_question,
            :author_cant_respond_to_own_poll

  belongs_to(
    :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  belongs_to(
    :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )

  has_one(
    :poll,
    through: :question,
    source: :poll
  )

  def sibling_responses
    question
      .responses
      .where("? IS NULL OR responses.id != ?", id, id)
  end

  private
  def respondent_has_not_already_answered_question
    if sibling_responses.where("user_id = ?", user_id).exists?
      errors[:base] << "can't respond to same question multiple times"
    end
  end

  def author_cant_respond_to_own_poll
    if question.poll.author.id == user_id
      errors[:base] << "author can't respond to his/her own poll"
    end
  end

end
