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

  describe '#generate_invitation_token!' do
    let(:submission) { FactoryGirl.create(:submission) }

    it 'generates invitation token' do
      submission.generate_invitation_token!
      expect(submission.invitation_token).not_to be_nil
      expect(submission.invitation_token_created_at).not_to be_nil
    end
  end

  describe '#invitation_expired?' do
    let(:expired_submission) do
      FactoryGirl.build(
        :submission,
        invitation_token: 'xxx',
        invitation_token_created_at: 1.week.ago - 1,
        invitation_confirmed: false)
    end
    let(:confirmed_submission) do
      FactoryGirl.build(
      :submission,
      invitation_token: 'xxx',
      invitation_token_created_at: 1.week.ago - 1,
      invitation_confirmed: true)
    end
    let(:not_invited_submission) do
      FactoryGirl.build(
        :submission,
        invitation_token: nil,
        invitation_token_created_at: nil,
        invitation_confirmed: false)
    end

    it 'returns true when token expired and invitation is not confirmed' do
      expect(expired_submission.invitation_expired?).to be true
    end

    it 'returns false for confirmed submission' do
      expect(confirmed_submission.invitation_expired?).to be false
    end

    it 'raise an error for not ivited submission' do
      expect{ not_invited_submission.invitation_expired? }.to raise_error('Submission not invited!')
    end
  end
end
