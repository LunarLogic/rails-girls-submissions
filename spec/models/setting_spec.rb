require "rails_helper"

RSpec.describe Submission, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:setting)).to be_valid
  end

  it "validates available_spots" do
    expect(FactoryGirl.build(:setting, available_spots: -1)).not_to be_valid
    expect(FactoryGirl.build(:setting, available_spots: "a")).not_to be_valid
    expect(FactoryGirl.build(:setting, available_spots: 4.32)).not_to be_valid
  end

  it "validates that preparation comes before registration" do
    params = {
      beginning_of_preparation_period: "Wed, 22 Jun 2016 12:00:00 CEST +02:00",
      beginning_of_registration_period: "Wed, 22 Jun 2016 00:00:00 CEST +02:00"
    }
    expect(FactoryGirl.build(:setting, params)).not_to be_valid
  end

  it "validates that registration comes before closed" do
    params = {
      beginning_of_registration_period: "Wed, 22 Jun 2016 12:00:00 CEST +02:00",
      beginning_of_closed_period: "Wed, 22 Jun 2016 00:00:00 CEST +02:00"
    }
    expect(FactoryGirl.build(:setting, params)).not_to be_valid
  end
end
