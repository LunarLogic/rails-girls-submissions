class SubmissionCreator
  def self.build(submission_params, answers_params)
    submission = Submission.new(submission_params)
    answers = Answer.collection(answers_params)

    new(submission, answers, SubmissionRejector.new)
  end

  def initialize(submission, answers, submission_rejector)
    @submission = submission
    @answers = answers
    @submission_rejector = submission_rejector
  end

  def call
    submission_rejector.reject_if_any_rules_broken(submission)

    if submission_and_answers_are_valid
      save(submission, answers)
      result_value = true
    else
      result_value = false
    end

    Result.new({ submission: submission, answers: answers }, result_value)
  end

  private

  attr_reader :submission, :answers, :submission_rejector

  def save(submission, answers)
    submission.save

    answers.map do |a|
      a.submission = submission
      a.save
    end
  end

  def submission_and_answers_are_valid
    # so that it runs :valid? on all of the objects and sets errors if necessary
    submission_is_valid = submission.valid?
    answers_are_valid = answers.map(&:valid?).all?
    submission_is_valid && answers_are_valid
  end
end
