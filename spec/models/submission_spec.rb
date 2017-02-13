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
end
