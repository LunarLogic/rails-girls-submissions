require 'rails_helper'

describe SubmissionRepository do
  let(:setting) { FactoryGirl.build(:setting, available_spots: 1) }
  let(:submission_repository) { described_class.new }

  before { allow(Setting).to receive(:get).and_return(setting) }

  context "all submissions are divided into valid and (automatically) rejected" do
    let!(:valid_sub) { FactoryGirl.create(:submission) }
    let!(:rejected_sub) { FactoryGirl.create(:submission, rejected: true) }

    describe "#rejected" do
      subject { submission_repository.rejected }

      it { is_expected.to eq [rejected_sub] }
    end

    describe "#valid" do
      subject { submission_repository.valid }

      it { is_expected.to eq [valid_sub] }
    end
  end

  context "valid submissions are divided into rated and to rate" do
    let!(:rated_sub) { FactoryGirl.create(:submission, :with_rates,
      rates_num: setting.required_rates_num) }
    let!(:unrated_sub) { FactoryGirl.create(:submission, :with_rates,
      rates_num: (setting.required_rates_num - 1)) }

    describe "#rated" do
      subject { submission_repository.rated }

      it "returns valid submissions with a required rates number" do
        expect(subject).to eq [rated_sub]
      end
    end

    describe "#results" do
      subject { submission_repository.results }
      before { allow(submission_repository).to receive(:rated).and_return([]) }

      it "is an alias for rated" do
        expect(subject).to eq []
      end
    end

    describe "#to_rate" do
      subject { submission_repository.to_rate }

      it "returns valid submissions that don't have a required rates number" do
        expect(subject).to eq [unrated_sub]
      end
    end
  end

  context "navigation between submissions" do
    let!(:to_rate_submission_1) { FactoryGirl.create(:to_rate_submission, created_at: 1.hour.ago) }
    let!(:to_rate_submission_2) { FactoryGirl.create(:to_rate_submission) }
    let(:submissions) { Submission.all }

    describe "#next" do
      context "when there is a next submission to rate" do
        subject { submission_repository.next(submissions, to_rate_submission_1) }

          it "returns the next submission to rate" do
            expect(subject).to eq to_rate_submission_2
          end
        end

      context "when there are no more submissions after" do
        subject { submission_repository.next(submissions, to_rate_submission_2) }

        it "doesn't return anything" do
          expect(subject).to eq nil
        end
      end
    end

    describe "#previous" do
      context "when there is a previous submission to rate" do
        subject { submission_repository.previous(submissions, to_rate_submission_2) }

          it "returns the previous submission to rate" do
            expect(subject).to eq to_rate_submission_1
          end
        end

      context "when there are no more submissions before" do
        subject { submission_repository.previous(submissions, to_rate_submission_1) }

        it "doesn't return anything" do
          expect(subject).to eq nil
        end
      end
    end
  end

  context "mailer methods" do
    before { allow(Setting).to receive(:get).and_return(setting) }
    let(:setting) { instance_double(Setting, available_spots: 4, days_to_confirm_invitation: 7, required_rates_num: 1) }

    let(:two_days_ago) { (Setting.get.days_to_confirm_invitation.days - 2.days).ago }
    let(:expired) { (Setting.get.days_to_confirm_invitation.days + 1.day).ago }

    let(:unrated_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        full_name: "Unrated",
        rates_num: setting.required_rates_num - 1)
    end

    let(:invited_expiring_in_two_days_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        :invited,
        full_name: "Invited expiring in two days",
        invitation_token_created_at: two_days_ago,
        rates_num: setting.required_rates_num)
    end

    let(:invited_expiring_in_two_days_submission_2) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        :invited,
        full_name: "Invited expiring in two days 2",
        invitation_token_created_at: two_days_ago,
        rates_num: setting.required_rates_num)
    end

    let(:expired_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        :invited,
        full_name: "Expired",
        invitation_token_created_at: expired,
        rates_num: setting.required_rates_num)
    end

    let(:confirmed_submission) do
      FactoryGirl.create(
        :submission,
        :invited,
        :with_rates,
        full_name: "Confirmed",
        invitation_token_created_at: two_days_ago,
        invitation_confirmed: true,
        rates_num: setting.required_rates_num)
    end

    let(:confirmed_submission_2) do
      FactoryGirl.create(
        :submission,
        :invited,
        :with_rates,
        full_name: "Confirmed 2",
        invitation_token_created_at: two_days_ago,
        invitation_confirmed: true,
        rates_num: setting.required_rates_num)
    end

    let(:not_invited_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        full_name: "Not invited",
        rates_num: setting.required_rates_num,
        rates_val: 5)
    end

    let(:not_invited_submission_2) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        full_name: "Not invited 2",
        rates_num: setting.required_rates_num,
        rates_val: 4)
    end

    let(:not_invited_over_the_limit_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        full_name: "Not invited over the limit",
        rates_num: setting.required_rates_num,
        rates_val: 1)
    end

    let!(:rejected_submission) {
      FactoryGirl.create(:submission, full_name: "Rejected", rejected: true)
    }

    describe "#to_invite_and_to_send_bad_news" do
      context "when some spots are confirmed and it's possible to invite more people at the moment" do
        let!(:list_of_submissions) { [
           unrated_submission,
           invited_expiring_in_two_days_submission,
           not_invited_submission,
           not_invited_submission_2,
           not_invited_over_the_limit_submission,
           confirmed_submission,
           rejected_submission,
        ] }
        let(:submissions_to_invite) { [not_invited_submission, not_invited_submission_2] }
        let(:submissions_to_send_bad_news) { [not_invited_over_the_limit_submission, rejected_submission, unrated_submission] }

        it "sends invitations and bad news to appropriate submissions" do
          actual_submissions_to_invite, actual_submissions_to_send_bad_news = submission_repository.to_invite_and_to_send_bad_news

          expect(actual_submissions_to_invite).to match_array(submissions_to_invite)
          expect(actual_submissions_to_send_bad_news).to match_array(submissions_to_send_bad_news)
        end
      end

      context "when no spots are confirmed and it's possible to invite more people at the moment" do
        let!(:list_of_submissions) { [
           unrated_submission,
           invited_expiring_in_two_days_submission,
           not_invited_submission,
           not_invited_submission_2,
           not_invited_over_the_limit_submission,
           rejected_submission,
        ] }
        let(:submissions_to_invite) { [
          not_invited_submission, not_invited_submission_2, not_invited_over_the_limit_submission
        ] }
        let(:submissions_to_send_bad_news) { [rejected_submission, unrated_submission] }

        it "sends invitations and bad news to appropriate submissions" do
          actual_submissions_to_invite, actual_submissions_to_send_bad_news = submission_repository.to_invite_and_to_send_bad_news

          expect(actual_submissions_to_invite).to match_array(submissions_to_invite)
          expect(actual_submissions_to_send_bad_news).to match_array(submissions_to_send_bad_news)
        end
      end

      context "when all the spots are confirmed or not expired yet" do
        let!(:list_of_submissions) { [
           unrated_submission,
           invited_expiring_in_two_days_submission,
           invited_expiring_in_two_days_submission_2,
           not_invited_submission,
           not_invited_submission_2,
           not_invited_over_the_limit_submission,
           confirmed_submission,
           confirmed_submission_2,
           rejected_submission,
        ] }
        let(:submissions_to_invite) { [] }
        let(:submissions_to_send_bad_news) { [
          not_invited_submission, not_invited_submission_2, not_invited_over_the_limit_submission,
          rejected_submission, unrated_submission,
        ] }

        it "sends invitations and bad news to appropriate submissions" do
          actual_submissions_to_invite, actual_submissions_to_send_bad_news = submission_repository.to_invite_and_to_send_bad_news

          expect(actual_submissions_to_invite).to match_array(submissions_to_invite)
          expect(actual_submissions_to_send_bad_news).to match_array(submissions_to_send_bad_news)
        end
      end

      context "when all the spots are confirmed or not expired yet and not invited submissions " \
        "already received bad news, except the unrated submission (because it just got created)" do
        let!(:list_of_submissions) { [
           unrated_submission,
           invited_expiring_in_two_days_submission,
           invited_expiring_in_two_days_submission_2,
           not_invited_submission.tap { |s| s.update!(bad_news_sent_at: Time.zone.now) },
           not_invited_submission_2.tap { |s| s.update!(bad_news_sent_at: Time.zone.now) },
           not_invited_over_the_limit_submission.tap { |s| s.update!(bad_news_sent_at: Time.zone.now) },
           confirmed_submission,
           confirmed_submission_2,
           rejected_submission.tap { |s| s.update!(bad_news_sent_at: Time.zone.now) },
        ] }
        let(:submissions_to_invite) { [] }
        let(:submissions_to_send_bad_news) { [unrated_submission] }

        it "sends invitations and bad news to appropriate submissions" do
          actual_submissions_to_invite, actual_submissions_to_send_bad_news = submission_repository.to_invite_and_to_send_bad_news

          expect(actual_submissions_to_invite).to match_array(submissions_to_invite)
          expect(actual_submissions_to_send_bad_news).to match_array(submissions_to_send_bad_news)
        end
      end
    end

    describe "#to_remind" do
      let!(:list_of_submissions) { [
        unrated_submission,
        invited_expiring_in_two_days_submission,
        not_invited_submission,
        not_invited_submission_2,
        not_invited_over_the_limit_submission,
        confirmed_submission
      ]}
      let(:submissions_to_invite) { [] }
      context "days_to_confirm_invitation is at least 2" do
        let(:submissions_to_remind) { [invited_expiring_in_two_days_submission] }

        subject { submission_repository.to_remind }

        it "returns those expiring in two days" do
          expect(subject).to eq(submissions_to_remind)
        end
      end

      context "days_to_confirm_invitation is less than 2" do
        let(:submissions_to_remind) { [] }
        subject { submission_repository.to_remind }

        before do
          allow(setting).to receive(:days_to_confirm_invitation).and_return(1)
          allow(invited_expiring_in_two_days_submission).to receive(:invitation_token_created_at)
            .and_return(6.hours.ago)
        end

        it "doesn't send reminders for such short deadlines" do
          expect(subject).to eq(submissions_to_remind)
        end
      end
    end
  end

  describe '#participants' do
    let!(:confirmed_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        :invited,
        invitation_confirmed: true,
        rates_num: setting.required_rates_num)
    end

    let!(:not_confirmed_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        :invited,
        rates_num: setting.required_rates_num)
    end
    subject { submission_repository.participants }

    it { expect(subject).to eq([confirmed_submission]) }
  end

  describe '#comments' do
    let(:submission) { double(comments: comments) }
    let(:comments) { double }
    before { allow(comments).to receive(:order) }

    it "delegates sorting comments to the db" do
      submission_repository.comments(submission)
      expect(submission).to have_received(:comments)
      expect(comments).to have_received(:order).with(:updated_at)
    end
  end

  describe '#rates' do
    let(:submission) { double(rates: rates) }
    let(:rates) { double }
    before { allow(rates).to receive(:order) }

    it "delegates sorting rates to the db" do
      submission_repository.rates(submission)
      expect(submission).to have_received(:rates)
      expect(rates).to have_received(:order).with(:updated_at)
    end
  end
end
