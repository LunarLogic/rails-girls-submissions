require "rails_helper"

describe Question, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:question)).to be_valid
  end

  it "requires a text" do
    expect(FactoryGirl.build(:question, text: nil)).not_to be_valid
    expect(FactoryGirl.build(:question, text: "")).not_to be_valid
  end
end
