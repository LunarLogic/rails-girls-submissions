require 'rails_helper'

describe InvitationsReminder do
  describe '#call' do
    let(:to_remind_submission) { instance_double(Submission) }
    let(:message_delivery) { instance_double ActionMailer::MessageDelivery }
    let(:event_dates) { double }
    let(:event_venue) { double }
    let(:contact_email) { double }

    subject { described_class.new(event_dates, event_venue, contact_email).call([to_remind_submission]) }

    it 'sends a reminder email' do
      expect(InvitationsMailer).to receive(:reminder_email)
        .with(to_remind_submission, event_dates, event_venue, contact_email).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_now)
      subject
    end
  end
end
