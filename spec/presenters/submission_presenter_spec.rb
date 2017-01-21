require 'rails_helper'

RSpec.describe SubmissionPresenter do
  let(:submission) { instance_double(Submission) }
  let(:submission_repository) { double }
  let(:submission_presenter) { described_class.new(submission, rates, submission_repository) }

  describe "is a delegator" do
    let(:rates) { double }
    subject { submission_presenter }

    it "acts like a Submission" do
      is_expected.to eq(submission)
      is_expected.not_to be_a(Submission)
    end
  end

  describe "#average_rate" do
    describe "when submission is unrated" do
      let(:rates) { double }
      subject { submission_presenter.average_rate }

      before { allow(submission).to receive(:rated?).and_return(false) }

      it { is_expected.to eq(nil) }
    end

    describe "when submission is rated" do
      # overriden with real object since average is calculated in the db
      let(:submission) { FactoryGirl.create(:submission, :rated, rate_value: 2) }
      let(:rates) { submission.rates }
      subject { submission_presenter.average_rate }

      it { is_expected.to eq(2) }
    end
  end

  describe "delegates methods to submission_repository" do
    describe "#next_to_rate" do
      let(:rates) { double }
      let(:result) { double }
      subject { submission_presenter.next_to_rate }

      before do
        date = double
        allow(submission).to receive(:created_at).and_return(date)
        allow(submission_repository).to receive(:next_to_rate).with(date).and_return(result)
      end

      it { is_expected.to eq(result) }
    end

    describe "#previous_to_rate" do
      let(:rates) { double }
      let(:result) { double }
      subject { submission_presenter.previous_to_rate }

      before do
        date = double
        allow(submission).to receive(:created_at).and_return(date)
        allow(submission_repository).to receive(:previous_to_rate).with(date).and_return(result)
      end

      it { is_expected.to eq(result) }
    end
  end

  describe "#rates_count" do
    let(:rates) { double }
    subject { submission_presenter.rates_count }

    before { allow(rates).to receive(:count).and_return(1) }

    it { is_expected.to eq(1) }
  end

  describe "#created_at" do
    let(:rates) { double }
    subject { submission_presenter.created_at }

    before do
      date = double
      allow(submission).to receive(:created_at).and_return(date)
      allow(date).to receive(:strftime).with("%m-%d-%Y").and_return("01-01-2000")
    end

    it { is_expected.to eq("01-01-2000") }
  end
end
