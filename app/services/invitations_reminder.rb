class InvitationsReminder
  def initialize(submission_repository: SubmissionRepository.new)
    @submission_repository = submission_repository
  end

  def call
    submissions_to_remind.each do |submission|
      remind_about_expiring_invitation(submission)
    end
  end

  private
  attr_reader :submission_repository

  def submissions_to_remind
    submission_repository.accepted_for_invitation_without_expired.select do |s|
      s.invitation_token_created_at > 6.days.ago && s.invitation_token_created_at < 5.days.ago
    end
  end

  def remind_about_expiring_invitation(submission)
    InvitationsMailer.reminder_email(submission).deliver_now
  end
end
