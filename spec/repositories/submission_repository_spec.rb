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

    describe "#to_rate" do
      subject { submission_repository.to_rate }

      it "returns valid submissions that don't have a required rates number" do
        expect(subject).to eq [unrated_sub]
      end
    end
  end

  context "rated submissions are divided into accepted and waitlist" do
    let!(:accepted_sub) { FactoryGirl.create(:submission, :with_rates,
      rates_num: setting.required_rates_num, rates_val: 2) }
    let!(:waitlist_sub) { FactoryGirl.create(:submission, :with_rates,
      rates_num: setting.required_rates_num, rates_val: 1) }

    describe "#accepted" do
      subject { submission_repository.accepted }

      it "returns first available_spots number of rated submissions ordered by the average rate" do
        expect(subject).to eq [accepted_sub]
      end
    end

    describe "#waitlist" do
      subject { submission_repository.waitlist }

      it "returns the rest of rated submissions ordered by the average rate" do
        expect(subject).to eq [waitlist_sub]
      end
    end
  end

  context "navigation between submissions" do
    let!(:to_rate_submission_1) { FactoryGirl.create(:to_rate_submission, created_at: 1.hour.ago) }
    let!(:to_rate_submission_2) { FactoryGirl.create(:to_rate_submission) }

    describe "#next_to_rate" do
      context "when there is a next submission to rate" do
        subject { submission_repository.next_to_rate(to_rate_submission_1.created_at) }

          it "returns the next submission to rate" do
            expect(subject).to eq to_rate_submission_2
          end
        end

      context "when there are no more submissions after" do
        subject { submission_repository.next_to_rate(to_rate_submission_2.created_at) }

        it "wraps around the submissions" do
          expect(subject).to eq to_rate_submission_1
        end
      end
    end

    describe "#previous_to_rate" do
      context "when there is a previous submission to rate" do
        subject { submission_repository.previous_to_rate(to_rate_submission_2.created_at) }

          it "returns the previous submission to rate" do
            expect(subject).to eq to_rate_submission_1
          end
        end

      context "when there are no more submissions before" do
        subject { submission_repository.previous_to_rate(to_rate_submission_1.created_at) }

        it "wraps around the submissions" do
          expect(subject).to eq to_rate_submission_2
        end
      end
    end
  end

  describe '#to_invite' do
    let(:setting) { FactoryGirl.build(:setting, available_spots: 3) }
    let!(:to_invite_submissions) { [to_invite_submission_1, to_invite_submission_2, to_invite_submission_3] }
    let!(:to_invite_submission_1) { FactoryGirl.create(:submission,
                                                       :with_rates,
                                                       confirmation_status: 'confirmed',
                                                       rates_num: setting.required_rates_num,
                                                       rates_val: 4) }
    let!(:to_invite_submission_2) { FactoryGirl.create(:submission,
                                                       :with_rates,
                                                       confirmation_status: 'awaiting',
                                                       rates_num: setting.required_rates_num,
                                                       rates_val: 3) }
    let!(:to_invite_submission_3) { FactoryGirl.create(:submission,
                                                       :with_rates,
                                                       confirmation_status: 'not_avaible',
                                                       rates_num: setting.required_rates_num,
                                                       rates_val: 2) }
    let!(:to_invite_submission_over_the_limit) { FactoryGirl.create(:submission,
                                                                    :with_rates,
                                                                    confirmation_status: 'not_avaible',
                                                                    rates_num: setting.required_rates_num,
                                                                    rates_val: 1) }
    let!(:not_to_invite_submission) { FactoryGirl.create(:submission,
                                                         :with_rates,
                                                         confirmation_status: 'expired',
                                                         rates_num: setting.required_rates_num,
                                                         rates_val: 3) }

    subject { submission_repository.to_invite }

    it { expect(subject).to eq(to_invite_submissions) }
  end
end
