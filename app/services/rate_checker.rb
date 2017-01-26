class RateChecker
  def initialize(submission, user_id)
    @user_id = user_id
    @submission = submission
  end

  def current_user_rate_value
    rate = Rate.find_by(submission_id: submission.id, user_id: user_id)
    rate ? rate.value : 0
  end

  private
  attr_reader :user_id, :submission
end
