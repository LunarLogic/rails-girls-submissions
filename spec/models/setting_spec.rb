require "rails_helper"
require "models/shared/validations"

RSpec.describe Submission, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:setting)).to be_valid
  end

  include_examples :positive_present_integer, :setting, :available_spots
  include_examples :positive_present_integer, :setting, :required_rates_num
  include_examples :positive_present_integer, :setting, :days_to_confirm_invitation
  include_examples :present, :setting, :beginning_of_preparation_period
  include_examples :present, :setting, :beginning_of_registration_period
  include_examples :present, :setting, :beginning_of_closed_period
  include_examples :present, :setting, :event_start_date
  include_examples :present, :setting, :event_end_date
  include_examples :present, :setting, :event_url
  include_examples :present, :setting, :available_spots
  include_examples :present, :setting, :required_rates_num

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

  it "correctly calculates end_of_registration_period on read" do
    beginning_of_closed_period = Time.zone.parse('2016-06-27')
    expected_end_of_registration_period = Time.zone.parse('2016-06-26').end_of_day
    setting = FactoryGirl.build(:setting, {beginning_of_closed_period: beginning_of_closed_period})

    expect(setting.end_of_registration_period).to eq(expected_end_of_registration_period)
  end

  it "correctly calculates end_of_registration_period on write" do
    end_of_registration_period = Time.zone.parse('2016-06-26')
    expected_beginning_of_closed_period = Time.zone.parse('2016-06-27').beginning_of_day
    setting = FactoryGirl.build(:setting, {end_of_registration_period: end_of_registration_period})

    expect(setting.beginning_of_closed_period).to eq(expected_beginning_of_closed_period)
  end
end
