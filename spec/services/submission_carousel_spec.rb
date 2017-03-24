require 'rails_helper'

describe SubmissionCarousel do
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

  describe "#previous or #next" do
    let(:submission_repository) { double(first: nil, previous: nil, next: nil, last: nil) }

    # see sspec/services/submission_filter_guard_spec.rb
    context "when it shows a rated submission in a filter that's different that :rated" do
      let(:current_submission) { instance_double(Submission, status: :rated) }
      let(:carousel) { described_class.new(submission_repository, []) }

      it "shows the same submission" do
        expect(carousel.next(current_submission)).to eq(current_submission)
        expect(carousel.previous(current_submission)).to eq(current_submission)
      end
    end
  end
end
