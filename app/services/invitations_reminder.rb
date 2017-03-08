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

  def remind_about_expiring_invitation(submission)
    InvitationsMailer.reminder_email(submission).deliver_now
  end
end
