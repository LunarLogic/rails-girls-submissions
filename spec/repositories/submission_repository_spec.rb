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
    before { allow(Setting).to receive(:get).and_return(setting)}
    let(:setting) { instance_double(Setting, available_spots: 4, days_to_confirm_invitation: 7, required_rates_num: 1) }

    let(:confirmation_days) { Setting.get.days_to_confirm_invitation.days }

    let!(:unrated_submission) do
      FactoryGirl.create(:submission, :with_rates, rates_num: setting.required_rates_num - 1)
    end

    let!(:invited_expiring_in_two_days_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        invitation_token: 'xxx',
        invitation_token_created_at: (confirmation_days - 2.days).ago,
        invitation_confirmed: false,
        rates_num: setting.required_rates_num,
        rates_val: 3)
    end

    let!(:expired_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        invitation_token: 'zzz',
        invitation_token_created_at: (confirmation_days + 1.day).ago,
        invitation_confirmed: false,
        rates_num: setting.required_rates_num,
        rates_val: 4)
    end

    let!(:confirmed_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        invitation_token: 'yyy',
        invitation_token_created_at: (confirmation_days - 1.days - 1.hour).ago,
        invitation_confirmed: true,
        rates_num: setting.required_rates_num,
        rates_val: 4)
    end

    let!(:not_invited_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        invitation_token: nil,
        invitation_confirmed: false,
        rates_num: setting.required_rates_num,
        rates_val: 5)
    end

    let!(:not_invited_submission_2) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        invitation_token: nil,
        invitation_confirmed: false,
        rates_num: setting.required_rates_num,
        rates_val: 4)
    end

    let!(:not_invited_over_the_limit_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        invitation_token: nil,
        invitation_confirmed: false,
        rates_num: setting.required_rates_num,
        rates_val: 1)
    end

    describe "#to_invite" do
      context "when it's possible to invite more people at the moment" do
        let(:submissions_to_invite) { [not_invited_submission, not_invited_submission_2] }
        subject { submission_repository.to_invite }

        it { expect(subject).to eq(submissions_to_invite) }
      end

      context "when all the spots are confirmed or some mails are not confirmed and not expired " do
        let(:submissions_to_invite) { [] }
        let(:setting) { instance_double(Setting, available_spots: 2, days_to_confirm_invitation: 7, required_rates_num: 1) }
        subject { submission_repository.to_invite }

        it { expect(subject).to eq(submissions_to_invite) }
      end
    end

    describe "#to_remind" do
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
        invitation_token: 'yyy',
        invitation_confirmed: true,
        rates_num: setting.required_rates_num,
        rates_val: 4)
    end
    let!(:not_confirmed_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        invitation_token: 'yyy',
        invitation_confirmed: false,
        rates_num: setting.required_rates_num,
        rates_val: 4)
    end
    subject { submission_repository.participants }

    it { expect(subject).to eq([confirmed_submission]) }
  end
end
