require 'rails_helper'

RSpec.describe WaitingSubmissionsAcceptor do
  describe '.call' do
    before do
      allow(Setting).to receive(:get).and_return(FactoryGirl.create(:setting))
    end

    let!(:setting_values) do
      { accepted_threshold: FactoryGirl.build(:setting).accepted_threshold,
        waitlist_threshold: FactoryGirl.build(:setting).waitlist_threshold,
        required_rates_num: FactoryGirl.build(:setting).required_rates_num }
    end
    let!(:waitlist_submission1) { FactoryGirl.create(:waitlist_submission, :with_settings, setting_values) }
    let!(:waitlist_submission2) { FactoryGirl.create(:waitlist_submission, :with_settings, setting_values) }
    let!(:expired_submission1) do
      FactoryGirl.create(:submission, confirmation_token: 'dsa', confirmation_token_created_at: 1.month.ago)
    end
    let!(:expired_submission2) do
      FactoryGirl.create(:submission, confirmation_token: 'dsa', confirmation_token_created_at: 1.month.ago, confirmed: true)
    end

    it "sends email to waitlist submissions" do
      described_class.new.call
      waitlist_submission1.reload
      waitlist_submission2.reload
      expect(waitlist_submission1.confirmation_token).not_to be_nil
      expect(waitlist_submission2.confirmation_token).to be_nil
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end
end
