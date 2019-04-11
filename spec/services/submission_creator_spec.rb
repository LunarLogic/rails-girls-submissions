require 'rails_helper'

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.describe SubmissionCreator do
  describe "#call" do
    let(:submission) { FactoryGirl.build(:submission) }
    let(:answers) { FactoryGirl.build_list(:answer, 2) }
    let(:submission_rejector) { double(reject_if_any_rules_broken: nil) }

    subject { described_class.new(submission, answers, submission_rejector).call }

    context "when the submission and the answers are valid" do
      it "creates a new submission with answers" do
        expect { subject }.to change(Submission, :count).by(1).and change(Answer, :count).by(2)
        expect(subject.success).to eq(true)
        expect(subject.object).to eq({ submission: submission, answers: answers })
      end
    end

    context "when the submission is invalid" do
      let(:submission) { FactoryGirl.build(:submission, email: "foo") }

      it "doesn't create either the submission or the answers" do
        expect { subject }.to not_change(Submission, :count).and not_change(Answer, :count)
        expect(subject.success).to eq(false)
        expect(subject.object).to eq({ submission: submission, answers: answers })
      end
    end

    context "when any of the answers is invalid" do
      let(:invalid_answer) { FactoryGirl.build(:answer) }
      let(:answers) { FactoryGirl.build_list(:answer, 2) << invalid_answer }

      # At this moment you can't create an invalid Answer but the validation is implemented
      before { allow(invalid_answer).to receive(:valid?).and_return(false) }

      it "doesn't create either the submission or the answers" do
        expect { subject }.to not_change(Submission, :count).and not_change(Answer, :count)
        expect(subject.success).to eq(false)
        expect(subject.object).to eq({ submission: submission, answers: answers })
      end
    end
  end
end
