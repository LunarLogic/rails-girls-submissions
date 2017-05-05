require "rails_helper"

describe SubmissionsInviter do
  describe "#call" do
    let(:event_dates) { double }
    let(:event_venue) { double }
    let(:contact_email) { double }
    let(:logger) { double }

    subject { described_class.new(event_dates, event_venue, contact_email, logger).call(submissions) }

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

      context "and an excpetion is thrown down the line" do
        let(:error) { StandardError }

        before do
          allow(InvitationsMailer).to receive(:invitation_email).and_raise(error)
          allow(logger).to receive(:error).and_return(nil)
          allow(to_invite_submission).to receive(:update_attributes)
        end

        it "rollbacks the invitation token generation" do
          expect(to_invite_submission).to receive(:generate_invitation_token!)
          expect(InvitationsMailer).to receive(:invitation_email)
            .with(to_invite_submission, event_dates, event_venue, contact_email).and_raise(error)
          expect(logger).to receive(:error).with(error)
          expect(to_invite_submission).to receive(:update_attributes)
            .with({ invitation_token: nil, invitation_token_created_at: nil })

          subject
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
