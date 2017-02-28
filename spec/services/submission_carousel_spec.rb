require 'rails_helper'

describe SubmissionCarousel do
  describe "#self.build" do
    let(:filter) { :valid }
    let(:incorrect_filter) { :vld }

    before { stub_const("#{described_class}::FILTERS", [filter]) }

    subject { described_class.build(incorrect_filter) }

    it "raises ArgumentError if given filter is not in the list" do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  describe "#next" do
    let(:submission_repository) { double }

    context "when there is a next submission" do
      let(:current_submission) { double }
      let(:next_submission) { double }

      before do
        allow(submission_repository).to receive(:next).and_return(next_submission)
      end

      let(:carousel) { described_class.new(submission_repository, [current_submission, next_submission]) }
      subject { carousel.next(current_submission) }

      it "moves to it" do
        expect(subject).to eq(next_submission)
      end
    end

    context "when the current submission is the last one" do
      let(:current_submission) { double }
      let(:first_submission) { double }

      before do
        allow(submission_repository).to receive(:next).and_return(nil)
        allow(submission_repository).to receive(:first).and_return(first_submission)
      end

      let(:carousel) { described_class.new(submission_repository, [current_submission, first_submission]) }
      subject { carousel.next(current_submission) }

      it "moves around to the first submission in the list" do
        expect(subject).to eq(first_submission)
      end
    end
  end

  describe "#previous" do
    let(:submission_repository) { double }

    context "when there is a previous submission" do
      let(:current_submission) { double }
      let(:previous_submission) { double }

      before do
        allow(submission_repository).to receive(:previous).and_return(previous_submission)
      end

      let(:carousel) { described_class.new(submission_repository, [current_submission, previous_submission]) }
      subject { carousel.previous(current_submission) }

      it "moves to it" do
        expect(subject).to eq(previous_submission)
      end
    end

    context "when the current submission is the first one" do
      let(:current_submission) { double }
      let(:last_submission) { double }

      before do
        allow(submission_repository).to receive(:previous).and_return(nil)
        allow(submission_repository).to receive(:last).and_return(last_submission)
      end

      let(:carousel) { described_class.new(submission_repository, [current_submission, last_submission]) }
      subject { carousel.previous(current_submission) }

      it "moves around to the last submission in the list" do
        expect(subject).to eq(last_submission)
      end
    end
  end
end
