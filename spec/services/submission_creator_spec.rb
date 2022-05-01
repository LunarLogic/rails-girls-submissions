require 'rails_helper'

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.describe SubmissionCreator do
  describe "#call" do
    let(:submission) { FactoryBot.build(:submission) }
    let(:answer) { FactoryBot.build(:answer, submission: submission) }
    let(:submission_rejector) { double(reject_if_any_rules_broken: nil) }

    subject { described_class.new(submission, [answer], submission_rejector).call }

    context "when the submission is valid and all added questions are answered" do
      it "creates a new submission with answers" do
        expect { subject }.to change(Submission, :count).by(1).and change(Answer, :count).by(1)
        expect(subject.success).to eq(true)
        expect(subject.object).to eq({ submission: submission, answers: [answer] })
      end
    end

    context "when the submission is invalid" do
      let(:submission) { FactoryBot.build(:submission, email: "foo") }

      it "doesn't create either the submission or the answers" do
        expect { subject }.to not_change(Submission, :count).and not_change(Answer, :count)
        expect(subject.success).to eq(false)
        expect(subject.object).to eq({ submission: submission, answers: [answer] })
      end
    end
  end
end
