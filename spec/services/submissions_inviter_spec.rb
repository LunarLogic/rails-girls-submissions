require "rails_helper"

describe SubmissionsInviter do
  describe "#call" do
    subject(:result) {
      described_class.new(event_dates, event_venue, contact_email, available_spots)
                     .call(
                       to_invite: submissions_to_invite,
                       to_send_bad_news: submissions_to_send_bad_news,
                       deliver_now_or_later: deliver_now_or_later,
                     )
    }

    let(:event_dates) { double }
    let(:event_venue) { double }
    let(:contact_email) { double }
    let(:available_spots) { double }
    let(:deliver_now_or_later) { :now }

    context "when there are submissions to invite and to send bad news" do
      let(:to_invite_submission) { instance_double(Submission) }
      let(:to_send_bad_news_submission) { instance_double(Submission) }
      let(:invite_message_delivery) { instance_double(ActionMailer::MessageDelivery) }
      let(:bad_news_message_delivery) { instance_double(ActionMailer::MessageDelivery) }
      let(:submissions_to_invite) { [to_invite_submission] }
      let(:submissions_to_send_bad_news) { [to_send_bad_news_submission] }

      before do
        allow(Setting).to receive(:registration_period?).and_return(false)
        allow(to_invite_submission).to receive(:generate_invitation_token!)
        allow(to_send_bad_news_submission).to receive(:mark_bad_news_delivery!)
        allow(InvitationsMailer).to receive(:invitation_email).with(to_invite_submission, event_dates, event_venue, contact_email)
                                                              .and_return(invite_message_delivery)
        allow(InvitationsMailer).to receive(:bad_news_email).with(to_send_bad_news_submission, available_spots, contact_email)
                                                            .and_return(bad_news_message_delivery)
        allow(invite_message_delivery).to receive(:deliver_now)
        allow(bad_news_message_delivery).to receive(:deliver_now)
        allow(invite_message_delivery).to receive(:deliver_later)
        allow(bad_news_message_delivery).to receive(:deliver_later)
      end

      it "invites submissions and sends bad news" do
        expect(result.success).to eq(true)
        expect(result.message).to eq("You have sent the emails.")

        expect(to_invite_submission).to have_received(:generate_invitation_token!)
        expect(to_send_bad_news_submission).to have_received(:mark_bad_news_delivery!)
        expect(InvitationsMailer).to have_received(:invitation_email)
        expect(InvitationsMailer).to have_received(:bad_news_email)
        expect(invite_message_delivery).to have_received(:deliver_now)
        expect(bad_news_message_delivery).to have_received(:deliver_now)
      end

      context "when deliver_now_or_later: :later is passed" do
        let(:deliver_now_or_later) { :later }

        it "generates invitation tokens and delivers invitation & bad news emails later" do
          expect(result.success).to eq(true)
          expect(result.message).to eq("The emails will be delivered shortly.")

          expect(to_invite_submission).to have_received(:generate_invitation_token!)
          expect(to_send_bad_news_submission).to have_received(:mark_bad_news_delivery!)
          expect(InvitationsMailer).to have_received(:invitation_email)
          expect(InvitationsMailer).to have_received(:bad_news_email)
          expect(invite_message_delivery).to have_received(:deliver_later)
          expect(bad_news_message_delivery).to have_received(:deliver_later)
        end
      end

      context "when an exception is thrown down the line when sending an invitation" do
        let(:error) { StandardError }

        before do
          allow(InvitationsMailer).to receive(:invitation_email).and_raise(error)
        end

        it "rollbacks the invitation token generation" do
          submission = FactoryBot.create(:to_rate_submission)

          expect {
            described_class.new(event_dates, event_venue, contact_email, available_spots)
                           .call(
                             to_invite: [submission],
                             to_send_bad_news: [],
                             deliver_now_or_later: :now,
                           )
          }.to raise_error(error).and not_change { submission.reload.attributes } # rubocop:disable Lint/AmbiguousBlockAssociation

          expect(InvitationsMailer).to have_received(:invitation_email)
            .with(submission, event_dates, event_venue, contact_email)
        end
      end

      context "when an exception is thrown down the line when sending bad news" do
        let(:error) { StandardError }

        before do
          allow(InvitationsMailer).to receive(:bad_news_email).and_raise(error)
        end

        it "rollbacks bad news datetime change" do
          submission = FactoryBot.create(:to_rate_submission)

          expect {
            described_class.new(event_dates, event_venue, contact_email, available_spots)
                           .call(
                             to_invite: [],
                             to_send_bad_news: [submission],
                             deliver_now_or_later: :now,
                           )
          }.to raise_error(error).and not_change { submission.reload.attributes } # rubocop:disable Lint/AmbiguousBlockAssociation

          expect(InvitationsMailer).to have_received(:bad_news_email).with(submission, available_spots, contact_email)
        end
      end
    end

    context "when there are no submissions to invite or to send bad news" do
      before { allow(Setting).to receive(:registration_period?).and_return(false) }

      let(:submissions_to_invite) { [] }
      let(:submissions_to_send_bad_news) { [] }

      it "returns false" do
        expect(result.success).to eq(false)
        expect(result.message).to eq("There are no emails to send.")
      end
    end

    context "when the registration is open" do
      let(:submissions_to_invite) { [] }
      let(:submissions_to_send_bad_news) { [to_send_bad_news_submission] }
      let(:to_send_bad_news_submission) { instance_double(Submission) }

      before { allow(Setting).to receive(:registration_period?).and_return(true) }

      it "returns false" do
        expect(result.success).to eq(false)
        expect(result.message).to eq("Registration is still open")
      end
    end
  end
end
