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
    html :fluent
    css :fluent
    js :used
    ror :heard
    db :never
    programming_others :heard
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

    #
    # trait :with_settings do
    #   transient do
    #     accepted_threshold  4
    #     required_rates_num  3
    #   end
    # end
    #
    # factory :accepted_submission do
    #   rejected false
    #   after(:create) do |submission, evaluator|
    #     create_list(:rate, evaluator.required_rates_num, submission: submission, value: evaluator.accepted_threshold)
    #   end
    # end
    #
    # factory :waitlist_submission do
    #   rejected false
    #   after(:create) do |submission, evaluator|
    #     value = evaluator.accepted_threshold > 0 ? evaluator.accepted_threshold - 1 : 0
    #     create_list(:rate, evaluator.required_rates_num, submission: submission, value: value)
    #   end
    # end
    #
    # factory :unaccepted_rejected_submission do
    #   rejected true
    # end
    #
    # factory :unaccepted_not_rejected_submission do
    #   rejected false
    #   after(:create) do |submission, evaluator|
    #     create_list(:rate, evaluator.required_rates_num, submission: submission, value: 0)
    #   end
    # end
  end
end
