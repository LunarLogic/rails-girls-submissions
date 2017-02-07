require 'rails_helper'

describe SubmissionsInviter do
  describe '#call' do
    let(:accepted_submissions) { [to_invite_submission, already_invited_submission] }
    let(:to_invite_submission) { FactoryGirl.build(:submission, invitation_token: nil) }
    let(:already_invited_submission) { FactoryGirl.build(:submission, invitation_token: 'xxx') }
    let(:submission_repository) { SubmissionRepository.new }
    let(:message_delivery) { instance_double ActionMailer::MessageDelivery }
    subject { described_class.new(submission_repository: submission_repository).call }

    it 'invites submission' do
      expect(submission_repository).to receive(:accepted_for_invitation_without_expired).and_return(submissions)
      expect(submissions).to receive(:select).and_return([to_invite_submission])
      expect(to_invite_submission).to receive(:generate_invitation_token!)
      expect(InvitationsMailer).to receive(:invitation_email).with(to_invite_submission).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_now)
      subject
    end
  end
end
