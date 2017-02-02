require 'rails_helper'

RSpec.describe SubmissionsExpirationHandler do
  describe '#call' do
    let(:submissions_inviter) { SubmissionsInviter.new }
    let(:setting) { FactoryGirl.build(:setting, available_spots: 2) }

    subject { described_class.new(submissions_inviter: submissions_inviter).call }

    before { allow(Setting).to receive(:get).and_return(setting) }

    let!(:expired_submissions) do
      FactoryGirl.create_list(
        :submission, 2,
        :with_rates,
        confirmation_token_created_at: 1.week.ago - 1,
        confirmation_status: 'awaiting',
        rates_num: setting.required_rates_num,
        rates_val: 4)
    end
    let!(:confirmed_submission) do
      FactoryGirl.create(
        :submission,
        :with_rates,
        confirmation_token_created_at: 1.week.ago - 1,
        confirmation_status: 'confirmed',
        rates_num: setting.required_rates_num,
        rates_val: 4)
    end

    it 'expires correct submissions' do
      subject
      expect(expired_submissions[0].reload).to be_expired
      expect(expired_submissions[1].reload).to be_expired
      expect(confirmed_submission.reload).not_to be_expired       
    end

    it 'invites submissions' do
      expect(submissions_inviter).to receive(:call)
      subject
    end
  end
end
