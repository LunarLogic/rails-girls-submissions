require 'rails_helper'

RSpec.describe WaitingSubmissionsAcceptor do
  describe '.call' do
    let(:setting) { FactoryGirl.build(:setting, available_spots: 1) }

    before do
      ActionMailer::Base.deliveries.clear
      allow(Setting).to receive(:get).and_return(setting)
    end

    it "sends confirmation email to waitlist submission and rejects expired" do
      waitlist_submission = FactoryGirl.create(:submission, :with_rates,
        rates_num: setting.required_rates_num, rates_val: 1)
      expired_submission = FactoryGirl.create(:submission, :with_rates,
        rates_num: setting.required_rates_num, rates_val: 2, confirmation_token: 'dsa', confirmation_token_created_at: 1.month.ago)

      described_class.new.call

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(expired_submission.reload.rejected).to be true
    end
  end
end
