FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@domain#{n}.com" }
    password 'password'
    password_confirmation 'password'
    sequence(:nickname) { |n| "user#{n}" }
  end
end
