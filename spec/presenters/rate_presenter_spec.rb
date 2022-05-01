require 'rails_helper'

RSpec.describe RatePresenter do
  let!(:rate) { FactoryBot.create(:rate) }
  subject { described_class.new(rate, rate.user) }

  it "presents rate's user nickname" do
    expect(subject.user_nickname).to eq(rate.user.nickname)
  end

  it "presents rate's value" do
    expect(subject.value).to eq(rate.value)
  end
end
