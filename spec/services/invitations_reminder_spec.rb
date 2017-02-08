require 'rails_helper'

describe InvitationsReminder do
  describe '#call' do
    let(:accepted_submissions) { [day_before_expiration_submissions, two_days_before_expiration_submission].flatten }
    let(:day_before_expiration_submissions) do
      FactoryGirl.build_list(:submission, 2, invitation_token_created_at: 1.week.ago + 1.day + 1.hour)
    end
    let(:two_days_before_expiration_submission) do
      FactoryGirl.build(:submission, invitation_token_created_at: 1.week.ago + 2.day + 1.hour)
    end
    let(:submission_repository) { instance_double SubmissionRepository }
    let(:invitations_mailer) { instance_double InvitationsMailer }
    let(:message_delivery) { instance_double ActionMailer::MessageDelivery }
    subject { described_class.new(submission_repository: submission_repository).call }

    it 'send reminder email to submissions expiring the next day' do
      expect(submission_repository)
        .to receive(:accepted_for_invitation_without_expired).and_return(accepted_submissions)
      expect(InvitationsMailer)
        .to receive(:reminder_email)
          .with(day_before_expiration_submissions[0]).and_return(message_delivery)
      expect(InvitationsMailer)
        .to receive(:reminder_email)
          .with(day_before_expiration_submissions[1]).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_now).twice
      subject
    end
  end
end
