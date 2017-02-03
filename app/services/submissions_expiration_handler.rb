class SubmissionsExpirationHandler
  def initialize(submissions_inviter: SubmissionsInviter.new, submissions_expirer: SubmissionsExpirer.new)
    @submissions_inviter = submissions_inviter
    @submissions_expirer = submissions_expirer
  end

  def call
    expire_submissions
    invite_submissions
  end

  private
  attr_reader :submissions_inviter, :submissions_expirer

  def expire_submissions
    submissions_expirer.call
  end

  def invite_submissions
    submissions_inviter.call
  end
end
