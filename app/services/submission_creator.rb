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

    if submission.valid?
      begin
        save!(submission, answers)
      rescue ActiveRecord::RecordInvalid => _e
        return Result.new({ submission: submission, answers: answers }, false)
      end
      result_value = true
    else
      result_value = false
    end

    Result.new({ submission: submission, answers: answers }, result_value)
  end

  private

  attr_reader :submission, :answers, :submission_rejector

  def save!(submission, answers)
    answers.map do |a|
      a.submission = submission
      a.save!
    end

    submission.save!
  end
end
