require 'rails_helper'

describe SubmissionRepository do

  before do
    allow(Setting).to receive(:get).and_return(FactoryGirl.create(:setting))
  end

  let!(:setting_values) do
    { accepted_threshold: FactoryGirl.build(:setting).accepted_threshold,
      waitlist_threshold: FactoryGirl.build(:setting).waitlist_threshold,
      required_rates_num: FactoryGirl.build(:setting).required_rates_num }
  end

  let!(:submission_repository) { described_class.new }
  let!(:accepted_submission) { FactoryGirl.create(:accepted_submission, :with_settings, setting_values) }
  let!(:waitlist_submission) { FactoryGirl.create(:waitlist_submission, :with_settings, setting_values) }
  let!(:unaccepted_not_rejected_submission) { FactoryGirl.create(:unaccepted_not_rejected_submission, :with_settings, setting_values) }
  let!(:unaccepted_rejected_submission)  { FactoryGirl.create(:unaccepted_rejected_submission, :with_settings, setting_values) }
  let!(:to_rate_submission_1) { FactoryGirl.create(:to_rate_submission, created_at: 1.hour.ago) }
  let!(:to_rate_submission_2) { FactoryGirl.create(:to_rate_submission) }
  let(:to_rate_submissions) { [to_rate_submission_2, to_rate_submission_1] }
  let!(:better_accepted_submission) {
    FactoryGirl.create(:accepted_submission, :with_settings, accepted_threshold: FactoryGirl.build(:setting).accepted_threshold + 1)
  }

  describe "#accepted" do
    subject { submission_repository.accepted }

    it "returns submissions that are not rejected or are rated and the average rate is equal to or above accepted_threshold" do
      expect(subject).to eq [better_accepted_submission, accepted_submission]
    end
  end

  describe "#waitlist" do
    subject { submission_repository.waitlist }

    it "returns submissions that are not rejected or are rated and the average rate is equal to or above waitlist_threshold and their average is below accepted_threshold" do
      expect(subject).to eq [waitlist_submission]
    end
  end

  describe "#unaccepted" do
    subject { submission_repository.unaccepted }

    it "returns submissions that are either rejected or are rated and the average rate is below waitlist_threshold" do
      lists_diff = subject - [unaccepted_rejected_submission, unaccepted_not_rejected_submission]
      expect(lists_diff).to eq []
    end
  end

  describe "#rejected" do
    subject { submission_repository.rejected }

    it "returns submissions that are rejected" do
      expect(subject).to eq [unaccepted_rejected_submission]
    end
  end

  describe "#rated" do
    subject { submission_repository.rated }

    it "returns submissions that are rated" do
      lists_diff = subject - [accepted_submission, waitlist_submission, unaccepted_not_rejected_submission, better_accepted_submission]
      expect(lists_diff).to eq []
    end
  end

  describe "#to_rate" do
    subject { submission_repository.to_rate }

    it "returns submissions that are not rejected, but are not rated yet" do
      expect(subject).to match_array to_rate_submissions
    end
  end

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
