require "rails_helper"

describe SubmissionsInviter do
  describe "#call" do
    let(:event_dates) { double }
    let(:event_venue) { double }
    let(:contact_email) { double }
    let(:available_spots) { double }
    let(:deliver_now_or_later) { :now }

    subject {
      described_class.new(event_dates, event_venue, contact_email, available_spots)
                     .call(
                       to_invite: submissions_to_invite,
                       to_send_bad_news: submissions_to_send_bad_news,
                       deliver_now_or_later: deliver_now_or_later,
                     )
    }

    context "there are submissions to invite and to send bad news" do
      before { allow(Setting).to receive(:registration_period?).and_return(false) }

      let(:to_invite_submission) { instance_double(Submission) }
      let(:to_send_bad_news_submission) { instance_double(Submission) }
      let(:invite_message_delivery) { instance_double(ActionMailer::MessageDelivery) }
      let(:bad_news_message_delivery) { instance_double(ActionMailer::MessageDelivery) }
      let(:submissions_to_invite) { [to_invite_submission] }
      let(:submissions_to_send_bad_news) { [to_send_bad_news_submission] }

      it "invites submissions and sends bad news" do
        expect(to_invite_submission).to receive(:generate_invitation_token!)
        expect(to_send_bad_news_submission).to receive(:mark_bad_news_delivery!)
        expect(InvitationsMailer).to receive(:invitation_email)
          .with(to_invite_submission, event_dates, event_venue, contact_email).and_return(invite_message_delivery)
        expect(InvitationsMailer).to receive(:bad_news_email)
          .with(to_send_bad_news_submission, available_spots, contact_email).and_return(bad_news_message_delivery)
        expect(invite_message_delivery).to receive(:deliver_now)
        expect(bad_news_message_delivery).to receive(:deliver_now)
        expect(subject.success).to eq(true)
        expect(subject.message).to eq("You have sent the emails.")
      end

      context "and deliver_now_or_later: :later is passed" do
        let(:deliver_now_or_later) { :later }

        it "generates invitation tokens and delivers invitation & bad news emails later" do
          expect(to_invite_submission).to receive(:generate_invitation_token!)
          expect(to_send_bad_news_submission).to receive(:mark_bad_news_delivery!)
          expect(InvitationsMailer).to receive(:invitation_email)
            .with(to_invite_submission, event_dates, event_venue, contact_email).and_return(invite_message_delivery)
          expect(InvitationsMailer).to receive(:bad_news_email)
            .with(to_send_bad_news_submission, available_spots, contact_email).and_return(bad_news_message_delivery)
          expect(invite_message_delivery).to receive(:deliver_later)
          expect(bad_news_message_delivery).to receive(:deliver_later)
          expect(subject.success).to eq(true)
          expect(subject.message).to eq("The emails will be delivered shortly.")
        end
      end

      context "and an exception is thrown down the line when sending an invitation" do
        let(:error) { StandardError }

        before do
          allow(InvitationsMailer).to receive(:invitation_email).and_raise(error)
        end

        it "rollbacks the invitation token generation" do
          submission = FactoryBot.create(:to_rate_submission)
          expect(InvitationsMailer).to receive(:invitation_email)
            .with(submission, event_dates, event_venue, contact_email).and_raise(error)

          expect {
            described_class.new(event_dates, event_venue, contact_email, available_spots)
                           .call(
                             to_invite: [submission],
                             to_send_bad_news: [],
                             deliver_now_or_later: :now,
                           )
          }.to raise_error(error).and not_change { submission.reload.attributes } # rubocop:disable Lint/AmbiguousBlockAssociation
        end
      end

      context "and an exception is thrown down the line when sending bad news" do
        let(:error) { StandardError }

        before do
          allow(InvitationsMailer).to receive(:bad_news_email).and_raise(error)
        end

        it "rollbacks bad news datetime change" do
          submission = FactoryBot.create(:to_rate_submission)
          expect(InvitationsMailer).to receive(:bad_news_email)
            .with(submission, available_spots, contact_email).and_raise(error)

          expect {
            described_class.new(event_dates, event_venue, contact_email, available_spots)
                           .call(
                             to_invite: [],
                             to_send_bad_news: [submission],
                             deliver_now_or_later: :now,
                           )
          }.to raise_error(error).and not_change { submission.reload.attributes } # rubocop:disable Lint/AmbiguousBlockAssociation
        end
      end
    end

    context "there are no submissions to invite or to send bad news" do
      before { allow(Setting).to receive(:registration_period?).and_return(false) }

      let(:submissions_to_invite) { [] }
      let(:submissions_to_send_bad_news) { [] }

      it "returns false" do
        expect(subject.success).to eq(false)
        expect(subject.message).to eq("There are no emails to send.")
      end
    end

    context "the registration is open" do
      let(:to_send_bad_news_submission) { instance_double(Submission) }

      before { allow(Setting).to receive(:registration_period?).and_return(true) }

      let(:submissions_to_invite) { [] }
      let(:submissions_to_send_bad_news) { [to_send_bad_news_submission] }

      it "returns false" do
        expect(subject.success).to eq(false)
        expect(subject.message).to eq("Registration is still open")
      end
    end
  end
end
