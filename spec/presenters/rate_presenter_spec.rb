require 'rails_helper'

RSpec.describe RatePresenter do
  subject(:presented_rate) { described_class.new(rate, rate.user) }

  let!(:rate) { FactoryBot.create(:rate) }

  it "presents rate's user nickname" do
    expect(presented_rate.user_nickname).to eq(rate.user.nickname)
  end

  it "presents rate's value" do
    expect(presented_rate.value).to eq(rate.value)
  end
end
