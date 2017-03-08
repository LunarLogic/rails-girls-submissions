class InvitationsReminder
  def call(submissions)
    submissions.each { |submission| remind_about_expiring_invitation(submission) }
  end

  private

  def remind_about_expiring_invitation(submission)
    InvitationsMailer.reminder_email(submission).deliver_now
  end
end
