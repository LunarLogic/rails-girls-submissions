require 'rails_helper'

RSpec.describe SubmissionsExpirationHandler do
  describe '.call' do
    let(:setting) { FactoryGirl.build(:setting, available_spots: 1) }

    before do
      ActionMailer::Base.deliveries.clear
      allow(Setting).to receive(:get).and_return(setting)
    end

    it "sends confirmation email to waitlist submission and rejects expired" do
      waitlist_submission = FactoryGirl.create(
        :submission,
        :with_rates,
        rates_num: setting.required_rates_num,
        rates_val: 1,
        confirmation_status: 'not_avaible')
      expired_submission = FactoryGirl.create(
        :submission,
        :with_rates,
        rates_num: setting.required_rates_num,
        rates_val: 2,
        confirmation_token_created_at: 1.month.ago,
        confirmation_status: 'awaiting')

      described_class.build.call

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(expired_submission.reload).to be_expired
    end
  end
end
