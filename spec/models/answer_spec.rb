require "rails_helper"

describe Answer, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:answer)).to be_valid
    expect(FactoryBot.build(:answer, choice: nil)).not_to be_valid
  end
end
