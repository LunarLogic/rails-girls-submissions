require 'rails_helper'

RSpec.describe RateCreator do
  let!(:submission) { FactoryGirl.create(:submission) }
  let!(:user) { FactoryGirl.create(:user) }
  let(:new_value) { 3 }

  describe "#call" do
    context "when new rate" do
      subject { described_class.build(1, submission.id, user.id) }

      it "creates a rate" do
        result = subject.call
        expect(Rate.where(value: 1, submission_id: submission.id, user_id: user.id).first).not_to be_nil
        expect(result.success).to be true
      end
    end

    context "when existing rate" do
      subject { described_class.build(new_value, submission.id, user.id) }

      it "updates the rate" do
        result = subject.call

        expect { result }.not_to change(Rate, :count)
        expect(Rate.where(submission_id: submission.id, user_id: user.id).first.value).to eq new_value
        expect(result.success).to be true
      end
    end
  end
end
