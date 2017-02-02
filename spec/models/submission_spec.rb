require "rails_helper"

RSpec.describe Submission, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:submission)).to be_valid
  end

  it "requires a full_name" do
    expect(FactoryGirl.build(:submission, full_name: "")).not_to be_valid
  end

  it "requires a valid email" do
    expect(FactoryGirl.build(:submission, email: "invalid#email.io")).not_to be_valid
    expect(FactoryGirl.build(:submission, email: "invalid@emaiio")).not_to be_valid
  end

  it "requires age between 0 and 110" do
    expect(FactoryGirl.build(:submission, age: -30)).not_to be_valid
    expect(FactoryGirl.build(:submission, age: 130)).not_to be_valid
  end

  describe '#generate_confirmation_token!' do
    let(:submission) { FactoryGirl.create(:submission) }

    it 'generates confirmation token' do
      submission.generate_confirmation_token!
      expect(submission.confirmation_token).not_to be_nil
      expect(submission.confirmation_token_created_at).not_to be_nil
    end
  end

  describe "#past_confirmation_due_date?" do
    it "returns true when token expired and confirmation status hasn't yet changed" do
      submission = FactoryGirl.build(
        :submission,
        confirmation_status: 'awaiting',
        confirmation_token_created_at: 1.week.ago - 1)
      expect(submission.past_confirmation_due_date?).to be true
    end

    it "returns false when token expired but status is not awaiting" do
      confirmed_submission = FactoryGirl.build(
        :submission,
        confirmation_status: 'confirmed',
        confirmation_token_created_at: 1.week.ago - 1)
      expired_submission = FactoryGirl.build(
        :submission,
        confirmation_status: 'expired',
        confirmation_token_created_at: 1.week.ago - 1)
      not_invited_submission = FactoryGirl.build(
        :submission,
        confirmation_status: 'not_available',
        confirmation_token_created_at: 1.week.ago - 1)
      submissions = [confirmed_submission, expired_submission, not_invited_submission]

      expect(confirmed_submission).not_to be_past_confirmation_due_date
      expect(expired_submission).not_to be_past_confirmation_due_date
      expect(not_invited_submission).not_to be_past_confirmation_due_date
    end
  end
end
