require "rails_helper"

describe Answer, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:answer)).to be_valid
  end
end
