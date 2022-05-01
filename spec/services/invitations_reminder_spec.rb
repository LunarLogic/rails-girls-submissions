require 'rails_helper'

describe InvitationsReminder do
  describe '#call' do
    subject(:call) { described_class.new(event_dates, event_venue, contact_email).call([to_remind_submission]) }

    let(:to_remind_submission) { instance_double(Submission) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }
    let(:event_dates) { double }
    let(:event_venue) { double }
    let(:contact_email) { double }

    before do
      allow(InvitationsMailer).to receive(:reminder_email).with(to_remind_submission, event_dates, event_venue, contact_email)
                                                          .and_return(message_delivery)
      allow(message_delivery).to receive(:deliver_now)
    end

    it 'sends a reminder email' do
      allow(Setting).to receive(:registration_period?).and_return(false)

      call

      expect(InvitationsMailer).to have_received(:reminder_email)
      expect(message_delivery).to have_received(:deliver_now)
    end

    it "returns if the registration is closed" do
      allow(Setting).to receive(:registration_period?).and_return(true)

      call

      expect(InvitationsMailer).not_to have_received(:reminder_email)
    end
  end
end
