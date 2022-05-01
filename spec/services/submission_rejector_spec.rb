require 'rails_helper'

RSpec.describe SubmissionRejector do
  describe '#reject_if_any_rules_broken' do
    subject { described_class.new(rules) }

    context "when there are no rules" do
      let!(:rules) { [] }
      let!(:submission) { FactoryBot.create(:submission) }

      it "doesn't reject the submission" do
        subject.reject_if_any_rules_broken(submission)
        expect(submission.rejected).to equal(false)
      end
    end

    context "when no rules are broken" do
      let!(:rules) { [Rules::EnglishRule.new, Rules::FirstTimeRule.new] }
      let!(:submission) do
        FactoryBot.create(:submission, english: "fluent", first_time: true)
      end

      it "doesn't reject the submission" do
        subject.reject_if_any_rules_broken(submission)
        expect(submission.rejected).to equal(false)
      end
    end

    context "when some rules are broken" do
      let!(:rules) { [Rules::EnglishRule.new, Rules::FirstTimeRule.new] }
      let!(:submission) do
        FactoryBot.create(:submission, english: "none", first_time: true)
      end

      it "rejects the submission" do
        subject.reject_if_any_rules_broken(submission)
        expect(submission.rejected).to equal(true)
      end
    end
  end
end
