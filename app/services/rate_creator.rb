class RateCreator
  def self.build(value, submission_id, user_id)
    submission = Submission.find(submission_id)
    user = User.find(user_id)
    new(value, submission, user, RateChecker.new(submission.id, user.id))
  end

  def initialize(value, submission, user, rate_checker)
    @value = value
    @submission = submission
    @user = user
    @rate_checker = rate_checker
  end

  def call
    if rate_checker.user_has_already_rated?
      rate = Rate.find_by(user_id: user.id, submission_id: submission.id)
      success = rate.update_attribute(:value, value)
    else
      rate = Rate.new({ value: value, submission: submission, user: user })
      success = rate.save
    end

    Result.new(rate, success)
  end

  private
  attr_reader :value, :submission, :user, :rate_checker
end
