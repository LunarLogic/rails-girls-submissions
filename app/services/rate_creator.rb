class RateCreator
  def self.build(value, submission_id, user_id)
    submission = Submission.find(submission_id)
    user = User.find(user_id)
    rate_checker = RateChecker.new(submission, user.id)
    new(value, submission, user, rate_checker)
  end

  def initialize(value, submission, user, rate_checker)
    @value = value
    @submission = submission
    @user = user
    @rate_checker = rate_checker
  end

  def call
    rate = Rate.find_or_initialize_by(user_id: user.id, submission_id: submission.id)
    rate.value = value
    success = rate.save

    Result.new(rate, success)
  end

  private
  attr_reader :value, :submission, :user, :rate_checker
end
