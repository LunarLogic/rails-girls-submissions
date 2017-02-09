class AnswerPresenter
  def self.collection(answers)
    answers.map { |answer| new(answer, answer.question) }
  end

  def initialize(answer, question)
    @answer = answer
    @question = question
  end

  def question_text
    question.text
  end

  def value
    answer.value.gsub("_", " ")
  end

  private

  attr_reader :answer, :question
end
