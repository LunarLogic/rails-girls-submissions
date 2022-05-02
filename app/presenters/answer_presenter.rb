class AnswerPresenter
  def self.collection(answers)
    answers.map { |answer| new(answer, answer.question) }
  end

  def initialize(answer, question)
    @answer = answer
    @question = question
  end

  delegate :text, to: :question, prefix: true

  def choice
    answer.choice.gsub("_", " ")
  end

  private

  attr_reader :answer, :question
end
