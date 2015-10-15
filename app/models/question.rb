class Question < ActiveRecord::Base
  validates :text, presence: true

  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id
  )

  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )

  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )

  def bad_results
    results_hash = Hash.new(0)
    answer_choices.each do |answer|
      results_hash[answer.text] = answer.responses.count
    end
    results_hash
  end

  def results
    results_hash = Hash.new(0)
    answer_choices.includes(:responses).each do |answer|
      results_hash[answer.text] = answer.responses.length
    end
    results_hash
  end

  def results_sql
    results = Hash.new(0)
    answers = AnswerChoice.find_by_sql(<<-SQL, self.id)
      SELECT
        answer_choices.*, COUNT(responses.id) AS num_responses
      FROM
        answer_choices
        LEFT OUTER JOIN
        responses
        ON answer_choices.id = responses.answer_choice_id
      WHERE
        answer_choices.question_id = ?
      GROUP BY
        answer_choices.id
    SQL

    answers.each do |answer|
      results[answer.text] = answer.num_responses
    end

    results
  end
end
