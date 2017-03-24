require 'rails_helper'

RSpec.describe SubmissionPresenter do
  let(:user) { double }
  let(:rates) { double }
  let(:submission) { instance_double(Submission) }
  let(:submission_repository) { double }
  let(:submission_presenter) { described_class.new(submission, rates, submission_repository, user) }

  describe "is a delegator" do
    subject { submission_presenter }

    it "acts like a Submission" do
      is_expected.to eq(submission)
      is_expected.not_to be_a(Submission)
    end
  end

  describe "#average_rate" do
    describe "when submission is unrated" do
      subject { submission_presenter.average_rate }

      before { allow(submission).to receive(:rated?).and_return(false) }

      it { is_expected.to eq(nil) }
    end

    describe "when submission is rated" do
      before { FactoryGirl.create(:setting, required_rates_num: 2) }

      # overriden with real objects since average is calculated in the db
      let(:submission) { FactoryGirl.create(:submission, :with_rates, rates_num: 2, rates_val: 2) }
      let(:rates) { submission.rates }

      subject { submission_presenter.average_rate }

      it { is_expected.to eq(2) }
    end
  end

  describe "delegates methods to submission_repository" do
    describe "#next" do
      let(:result) { double }
      subject { submission_presenter.next }

      before do
        date = double
        allow(submission).to receive(:created_at).and_return(date)
        allow(submission_repository).to receive(:next).with(date).and_return(result)
      end

      it { is_expected.to eq(result) }
    end

    describe "#previous" do
      let(:result) { double }
      subject { submission_presenter.previous }

      before do
        date = double
        allow(submission).to receive(:created_at).and_return(date)
        allow(submission_repository).to receive(:previous).with(date).and_return(result)
      end

      it { is_expected.to eq(result) }
    end
  end

  describe "#rates_count" do
    subject { submission_presenter.rates_count }

    before { allow(rates).to receive(:count).and_return(1) }

    it { is_expected.to eq(1) }
  end

  describe "#created_at" do
    subject { submission_presenter.created_at }

    before do
      date = double
      allow(submission).to receive(:created_at).and_return(date)
      allow(date).to receive(:strftime).with("%m-%d-%Y").and_return("01-01-2000")
    end

    it { is_expected.to eq("01-01-2000") }
  end

  describe "#current_user_rate_value" do
    #overriden with a real objects
    let(:user) { FactoryGirl.create(:user) }
    let(:submission) { FactoryGirl.create(:submission) }

    context "when the user has rated the submission" do
      before do
        FactoryGirl.create(:rate, submission: submission, user: user, value: 1)
      end

      subject { submission_presenter.current_user_rate_value }

      it "returns its value" do
        expect(subject).to eq(1)
      end
    end

    context "when the user hasn't rated the submission yet" do
      subject { submission_presenter.current_user_rate_value }

      it "returns 0" do
        expect(subject).to eq(0)
      end
    end
  end

  describe "#codecademy_url" do
    subject { submission_presenter.codecademy_url }

    before { allow(submission).to receive(:codecademy_username).and_return("tim") }

    it { is_expected.to eq("https://www.codecademy.com/tim") }
  end

  describe "#invitation_status" do
    subject { submission_presenter.invitation_status }

    before { allow(submission).to receive(:invitation_status).and_return(:example_status) }
    it { is_expected.to eq("example status")}
  end

  describe "#status" do
    subject { submission_presenter.status }

    before { allow(submission).to receive(:status).and_return(:example_status) }
    it { is_expected.to eq("example status")}
  end
end
