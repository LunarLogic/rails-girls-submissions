FactoryGirl.define do
  factory :submission, aliases: [:to_rate_submission] do
    sequence(:full_name) { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@domain.com" }
    adult true
    description "I'm super nice!\nI'm super nice!\nI'm super nice!\n"
    english :basic
    operating_system :windows
    first_time true
    goals "Tons of money!\nTons of money!\nTons of money!\n"
    problems "I'm shortsighted - can't see money's a poor goal. :c"
    invitation_confirmed false
    invitation_token nil
    rejected false
    gender 'nb'

    trait :with_rates do
      transient do
        rates_num 3
        rates_val 3
      end

      after(:create) do |submission, ev|
        create_list(:rate, ev.rates_num, value: ev.rates_val, submission: submission)
      end
    end

    trait :invited do
      sequence(:invitation_token) { |n| "#{n}#{n}#{n}"}
      invitation_token_created_at { 2.days.ago }
    end
  end
end
