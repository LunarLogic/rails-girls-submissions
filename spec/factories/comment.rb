FactoryBot.define do
  factory :comment do
    association :submission
    association :user
    body { "comment body" }
  end
end
