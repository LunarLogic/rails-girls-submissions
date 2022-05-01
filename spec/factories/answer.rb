FactoryBot.define do
  factory :answer do
    association :submission
    association :question

    value 3
  end
end
