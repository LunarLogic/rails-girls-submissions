require 'rails_helper'

describe SubmissionsInviter do
  describe '#call' do
    let(:to_invite_submission) { instance_double(Submission) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }
    subject { described_class.new([to_invite_submission]).call }

    it 'invites submission' do
      expect(to_invite_submission).to receive(:generate_invitation_token!)
      expect(InvitationsMailer).to receive(:invitation_email)
        .with(to_invite_submission).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_now)
      subject
    end
  end
end
