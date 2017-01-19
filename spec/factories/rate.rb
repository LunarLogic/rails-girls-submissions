FactoryGirl.define do
  factory :rate do
    association :submission
    association :user
    value 1
  end
end
