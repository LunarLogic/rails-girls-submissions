require 'rails_helper'

RSpec.describe SubmissionFilterGuard do
  describe '#call' do
    subject(:result) { described_class.new(submission, filter, submission_repository).call }

    let(:submission) { instance_double("Submission", status: status) }
    let(:filter) { :symbol }
    let(:submission_repository) { instance_double("SubmissionRepository") }

    context "when filter is forbidden" do
      before { stub_const("#{described_class}::FILTERS", []) }

      let(:status) { nil }

      it "returns an error" do
        expect(result.success).to equal(false)
        expect(result.message).to eq(:forbidden_filter)
      end
    end

    context "when the submission doesn't belong to the filter" do
      before do
        stub_const("#{described_class}::FILTERS", [filter])
        allow(submission_repository).to receive(:send).with(filter).and_return([])
      end

      let(:status) { nil }

      it "returns an error" do
        expect(result.success).to equal(false)
        expect(result.message).to eq(:incorrect_filter)
      end

      context "when it's not because a to_rate submission was just rated" do
        let(:status) { :rated }

        it "doesn't return an error" do
          expect(result.success).to equal(true)
          expect(result.message).to eq(nil)
        end
      end
    end

    context "when the submission belongs to the filter" do
      before do
        stub_const("#{described_class}::FILTERS", [filter])
        allow(submission_repository).to receive(:send).with(filter).and_return([submission])
      end

      let(:status) { nil }

      it "returns a success" do
        expect(result.success).to equal(true)
        expect(result.message).to eq(nil)
      end
    end
  end
end
