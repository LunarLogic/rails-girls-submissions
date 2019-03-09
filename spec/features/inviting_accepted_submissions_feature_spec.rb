require 'rails_helper'

describe 'inviting accepted submissions' do
  let(:setting) { FactoryGirl.build(:setting, available_spots: 2) }
  let!(:user) { FactoryGirl.create(:user) }
  let(:confirmation_days) { Setting.get.days_to_confirm_invitation.days }

  before do
    ActionMailer::Base.deliveries.clear
    allow(Setting).to receive(:get).and_return(setting)
  end

  context "sending invitation emails" do
    let!(:accepted_submission) do
      FactoryGirl.create(
            :submission,
            :with_rates,
            invitation_token: nil,
            rates_num: setting.required_rates_num,
            rates_val: 1)
    end

    it 'sends only one invitation email to each accepted submission' do
      allow(Setting).to receive(:registration_period?).and_return(false)

      login_as(user, scope: :user)
      visit submissions_results_path
      click_link('Send')

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(setting.invitation_process_started).to be true
      expect(accepted_submission.reload.invitation_token).not_to be_nil
    end

    it "doesn't send invitation emails if the registration open" do
      allow(Setting).to receive(:registration_period?).and_return(true)

      login_as(user, scope: :user)
      visit submissions_results_path
      click_link('Send')

      expect(ActionMailer::Base.deliveries.count).to eq(0)
      expect(accepted_submission.reload.invitation_token).to be_nil
    end
  end

  context "confirming invitations" do
    it 'confirms submission' do
      invited_submission = FactoryGirl.create(
        :submission,
        :with_rates,
        invitation_token: 'xxx',
        invitation_token_created_at: Time.zone.now,
        invitation_confirmed: false,
        rates_num: setting.required_rates_num,
        rates_val: 1)

      visit submissions_confirm_invitation_path(invitation_token: invited_submission.invitation_token)
      expect(invited_submission.reload.invitation_confirmed).to be true
      expect(page).to have_text('confirmed')
    end

    it "doesn't confirm submission with expired invitation token" do
      invited_submission = FactoryGirl.create(
        :submission,
        :with_rates,
        invitation_token: 'zzz',
        invitation_token_created_at: confirmation_days.ago - 1,
        invitation_confirmed: false,
        rates_num: setting.required_rates_num,
        rates_val: 1)

      visit submissions_confirm_invitation_path(invitation_token: invited_submission.invitation_token)
      expect(invited_submission.reload.invitation_confirmed).to be false
      expect(page).to have_text('expired')
    end

    it 'show correct info when invitation is already confirmed but token expired' do
      confirmed_submission = FactoryGirl.create(
        :submission,
        :with_rates,
        invitation_token: 'yyy',
        invitation_token_created_at: confirmation_days.ago - 1,
        invitation_confirmed: true,
        rates_num: setting.required_rates_num,
        rates_val: 1)

      visit submissions_confirm_invitation_path(invitation_token: confirmed_submission.invitation_token)
      expect(page).to have_text('confirmed')
    end
  end

  context 'handling exceptions' do
    it 'missing invitation token' do
      visit submissions_confirm_invitation_path
      expect(page).to have_text('Something went wrong')
    end

    it 'submission not found' do
      visit submissions_confirm_invitation_path('uuu')
      expect(page).to have_text('Something went wrong')
    end
  end

  context "when the accepted list is empty" do
    it "makes `Send` link inactive" do
      login_as(user, scope: :user)
      visit submissions_results_path
      expect(page).not_to have_selector('a', text: 'Send')
    end
  end
end
