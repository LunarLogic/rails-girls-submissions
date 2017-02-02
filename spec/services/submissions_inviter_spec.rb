require 'rails_helper'

describe SubmissionsInviter do
  describe '#call' do
    let(:submission) { instance_double Submission }
    let(:submission_repository) { SubmissionRepository.new }
    let(:message_delivery) { instance_double ActionMailer::MessageDelivery }
    subject { described_class.new(submission_repository: submission_repository).call }

    it 'invites submission' do
      expect(submission_repository).to receive(:to_invite).and_return([submission])
      expect(submission).to receive(:generate_confirmation_token!)
      expect(submission).to receive(:awaiting!)
      expect(InvitationsMailer).to receive(:invitation_email).with(submission).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_now)
      subject
    end
  end
end
