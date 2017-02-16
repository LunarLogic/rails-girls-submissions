FactoryGirl.define do
  factory :submission, aliases: [:to_rate_submission] do
    sequence(:full_name) { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@domain.com" }
    age 20
    sequence(:codecademy_username) { |n| "user#{n}" }
    description "I'm super nice!\nI'm super nice!\nI'm super nice!\n"
    english :basic
    operating_system :windows
    first_time true
    goals "Tons of money!\nTons of money!\nTons of money!\n"
    problems "I'm shortsighted - can't see money's a shitty goal. :c"
    rejected false

    trait :with_rates do
      transient do
        rates_num 3
        rates_val 3
      end

      after(:create) do |submission, ev|
        create_list(:rate, ev.rates_num, value: ev.rates_val, submission: submission)
      end
    end
  end
end
