require 'rails_helper'

describe InvitationsReminder do
  describe '#call' do
    let(:to_remind_submission) { instance_double(Submission) }
    let(:message_delivery) { instance_double ActionMailer::MessageDelivery }
    subject { described_class.new([to_remind_submission]).call }

    it 'sends a reminder email' do
      expect(InvitationsMailer).to receive(:reminder_email)
        .with(to_remind_submission).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_now)
      subject
    end
  end
end
