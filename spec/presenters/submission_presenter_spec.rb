require 'rails_helper'

RSpec.describe SubmissionPresenter do
  subject { described_class.new(submission, rates) }
  let!(:rates) { submission.rates }

  describe do
    let!(:submission) { FactoryGirl.build(:submission) }

    it "acts like a Submission" do
      expect(subject).to eq(submission)
      expect(subject).not_to be_a(Submission)
    end
  end

  describe "#average_rate" do
    describe "when submission is unrated" do
      let!(:submission) { FactoryGirl.build(:submission) }

      it { expect(subject.average_rate).to eq(nil) }
    end

    describe "when submission is rated and has no rates" do
      before do
        allow(Setting).to receive(:get).and_return(
          FactoryGirl.create(:setting, required_rates_num: 0))
      end

      let!(:submission) do
        FactoryGirl.build(:submission, :rated, required_rates_num: 0)
      end

      it { expect(subject.average_rate).to eq(0) }
    end

    describe "when submission is rated and has some rates" do
      before do
        allow(Setting).to receive(:get).and_return(
          FactoryGirl.create(:setting, required_rates_num: 3))
      end

      let!(:submission) do
        FactoryGirl.build(:submission, :rated, { required_rates_num: 3, rate_value: 2 })
      end

      it { expect(subject.average_rate).to eq(2) }
    end
  end
end
