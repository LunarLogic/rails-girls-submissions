FactoryBot.define do
  factory :question do
    sequence(:text) { |i| "text#{i}" }
  end
end
