require 'rails_helper'

describe SubmissionsInviter do
  describe '#invite' do
    let(:submission) { instance_double Submission }
    let(:message_delivery) { instance_double ActionMailer::MessageDelivery }
    subject { described_class.new.invite(submission) }

    it 'invites submission' do
      expect(submission).to receive(:generate_confirmation_token!)
      expect(submission).to receive(:awaiting!)
      expect(ResultsMailer).to receive(:accepted_email).with(submission).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_now)
      subject
    end
  end
end
