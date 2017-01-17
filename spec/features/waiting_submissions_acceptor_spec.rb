require 'rails_helper'

RSpec.describe WaitingSubmissionsAcceptor do
  describe '.call' do
    let(:setting) { FactoryGirl.create(:setting) }

    let(:setting_values) do
      { accepted_threshold: setting.accepted_threshold,
        waitlist_threshold: setting.waitlist_threshold,
        required_rates_num: setting.required_rates_num }
    end

    before do
      ActionMailer::Base.deliveries.clear
      allow(Setting).to receive(:get).and_return(setting)
    end

    it "sends confirmation email to waitlist submission and rejects expired" do
      waitlist_submissions = FactoryGirl.create_list(:waitlist_submission, 2, :with_settings, setting_values)
      expired_submission = FactoryGirl.create(:submission, confirmation_token: 'dsa', confirmation_token_created_at: 1.month.ago)

      described_class.new.call

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(expired_submission.reload.rejected).to be true
    end
  end
end
