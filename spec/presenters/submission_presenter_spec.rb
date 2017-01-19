require 'rails_helper'

RSpec.describe SubmissionPresenter do
  subject { described_class.new(submission, rates, submissions_repository) }
  let!(:rates) { submission.rates }
  let!(:submissions_repository) { double }

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

  describe "delegates methods to submissions_repository" do
    let!(:submission) { FactoryGirl.create(:submission) }

    context "#next" do
      it do
        expect(submissions_repository).to receive(:next).with(submission.created_at)
        subject.next
      end
    end

    context "#previous" do
      it do
        expect(submissions_repository).to receive(:previous).with(submission.created_at)
        subject.previous
      end
    end
  end
end
