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

  it "validates required_rates_num" do
    expect(FactoryGirl.build(:setting, required_rates_num: -1)).not_to be_valid
    expect(FactoryGirl.build(:setting, required_rates_num: "a")).not_to be_valid
    expect(FactoryGirl.build(:setting, required_rates_num: 4.32)).not_to be_valid
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

  it "validates that event_start_date comes before event_end_date" do
    params = {
      event_start_date: "Thu, 23 Jun 2016 00:00:00 CEST +02:00",
      event_end_date: "Wed, 22 Jun 2016 00:00:00 CEST +02:00"
    }
    expect(FactoryGirl.build(:setting, params)).not_to be_valid
  end

  context "validates the presence" do
    it { expect(FactoryGirl.build(:setting, required_rates_num: nil)).not_to be_valid }
    it { expect(FactoryGirl.build(:setting, beginning_of_preparation_period: nil)).not_to be_valid }
    it { expect(FactoryGirl.build(:setting, beginning_of_registration_period: nil)).not_to be_valid }
    it { expect(FactoryGirl.build(:setting, beginning_of_closed_period: nil)).not_to be_valid }
    it { expect(FactoryGirl.build(:setting, event_start_date: nil)).not_to be_valid }
    it { expect(FactoryGirl.build(:setting, event_end_date: nil)).not_to be_valid }
    it { expect(FactoryGirl.build(:setting, event_url: nil)).not_to be_valid }
    it { expect(FactoryGirl.build(:setting, available_spots: nil)).not_to be_valid }
  end
end
