class InvitationsReminder
  def build
    new(SubmissionRepository.new.to_remind)
  end

  def initialize(submissions)
    @submissions = submissions
  end

  def call
    submissions.each { |submission| remind_about_expiring_invitation(submission) }
  end

  private
  attr_reader :submissions

  # def submissions_to_remind
  #   submission_repository.accepted_for_invitation_without_expired.select do |s|
  #     expiring_in_a_day?(s.invitation_token_created_at)
  #   end
  # end

  def remind_about_expiring_invitation(submission)
    InvitationsMailer.reminder_email(submission).deliver_now
  end
  #
  # def expiring_in_a_day?(token_creation_date)
  #   token_creation_date > (Setting.get.days_to_confirm_invitation - 1).days.ago &&
  #     token_creation_date < (Setting.get.days_to_confirm_invitation - 2).days.ago
  # end
end
