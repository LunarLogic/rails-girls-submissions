FactoryGirl.define do
  factory :setting do
    accepted_threshold 4
    waitlist_threshold 3
    required_rates_num 2
    beginning_of_preparation_period "2016-06-23 17:20:53 +0200"
    beginning_of_registration_period "2016-06-24 17:20:53 +0200"
    beginning_of_closed_period "2016-06-25 17:20:53 +0200"
    event_start_date "2016-04-16"
    event_end_date "2016-04-17"
    event_url "railsgirls.com/krakow"
  end
end
