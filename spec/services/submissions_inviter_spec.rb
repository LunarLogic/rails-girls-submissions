require "rails_helper"

describe SubmissionsInviter do
  describe "#call" do
    let(:to_invite_submission) { instance_double(Submission) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }
    let(:event_dates) { double }
    let(:event_venue) { double }
    let(:contact_email) { double }

    subject { described_class.new(event_dates, event_venue, contact_email).call(submissions) }

    context "there are submissions to invite" do
      before { allow(Setting).to receive(:registration_period?).and_return(true) }

      let(:submissions) { [to_invite_submission] }

      it "invites submissions and returns them" do
        expect(to_invite_submission).to receive(:generate_invitation_token!)
        expect(InvitationsMailer).to receive(:invitation_email)
          .with(to_invite_submission, event_dates, event_venue, contact_email).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_now)
        expect(subject).to eq(submissions)
      end
    end

    context "there are no submissions to invite" do
      before { allow(Setting).to receive(:registration_period?).and_return(true) }

      let(:submissions) { [] }

      it "returns false" do
        expect(subject).to eq(false)
      end
    end

    context "the registration is closed" do
      before { allow(Setting).to receive(:registration_period?).and_return(false) }

      let(:submissions) { [to_invite_submission] }

      it { is_expected.to eq(false) }
    end
  end
end
