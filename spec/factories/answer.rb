FactoryBot.define do
  factory :answer do
    association :submission
    association :question

    choice { 3 }
  end
end
