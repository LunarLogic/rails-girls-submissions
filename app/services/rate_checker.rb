class RateChecker
  def initialize(submission_id, user_id)
    @submission_id = submission_id
    @user_id = user_id
  end

  def user_has_already_rated?
    submission = Submission.find(submission_id)
    submission.rates.any? { |rate| rate.user_id == user_id }
  end

  def current_user_rate_value
    rate = Rate.find_by(submission_id: submission_id, user_id: user_id)
    return 0 unless rate

    rate.value
  end

  private
  attr_reader :submission_id, :user_id
end
