require "rails_helper"

describe SubmissionsInviter do
  describe "#call" do
    let(:event_dates) { double }
    let(:event_venue) { double }
    let(:contact_email) { double }

    subject { described_class.new(event_dates, event_venue, contact_email).call(submissions) }

    context "there are submissions to invite" do
      before { allow(Setting).to receive(:registration_period?).and_return(false) }

      let(:to_invite_submission) { instance_double(Submission) }
      let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }
      let(:submissions) { [to_invite_submission] }

      it "invites submissions and returns them" do
        expect(to_invite_submission).to receive(:generate_invitation_token!)
        expect(InvitationsMailer).to receive(:invitation_email)
          .with(to_invite_submission, event_dates, event_venue, contact_email).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_now)
        expect(subject.success).to eq(true)
        expect(subject.message).to eq("You have sent the emails.")
      end

      context "and an exception is thrown down the line" do
        let(:error) { StandardError }

        before do
          allow(InvitationsMailer).to receive(:invitation_email).and_raise(error)
        end

        it "rollbacks the invitation token generation" do
          submission = FactoryGirl.create(:to_rate_submission)
          expect(InvitationsMailer).to receive(:invitation_email)
            .with(submission, event_dates, event_venue, contact_email).and_raise(error)

          expect {
            described_class.new(event_dates, event_venue, contact_email).call([submission])
          }.to raise_error(error).and not_change { submission.reload.attributes }
        end
      end
    end

    context "there are no submissions to invite" do
      before { allow(Setting).to receive(:registration_period?).and_return(false) }

      let(:submissions) { [] }

      it "returns false" do
        expect(subject.success).to eq(false)
        expect(subject.message).to eq("There are no emails to send.")
      end
    end

    context "the registration is closed" do
      let(:to_invite_submission) { instance_double(Submission) }

      before { allow(Setting).to receive(:registration_period?).and_return(true) }

      let(:submissions) { [to_invite_submission] }

      it "returns false" do
        expect(subject.success).to eq(false)
        expect(subject.message).to eq("Registration is still open")
      end
    end
  end
end
