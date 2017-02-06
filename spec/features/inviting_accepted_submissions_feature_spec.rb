require 'rails_helper'

describe 'inviting accepted submissions' do
  let(:setting) { FactoryGirl.build(:setting, available_spots: 2) }
  let!(:user) { FactoryGirl.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
    allow(Setting).to receive(:get).and_return(setting)
  end

  it 'sends only one invitation email to each accepted submission' do
    accepted_submission = FactoryGirl.create(
      :submission,
      :with_rates,
      invitation_token: nil,
      rates_num: setting.required_rates_num,
      rates_val: 1)

    login_as(user, scope: :user)
    visit submissions_results_path
    click_link('Send')
    click_link('Send')
    expect(ActionMailer::Base.deliveries.count).to eq(1)
    expect(accepted_submission.reload.invitation_token).not_to be_nil
  end

  it 'confirms submission' do
    invited_submission = FactoryGirl.create(
      :submission,
      :with_rates,
      invitation_token: 'xxx',
      invitation_token_created_at: Time.now,
      invitation_confirmed: false,
      rates_num: setting.required_rates_num,
      rates_val: 1)

    visit submissions_confirm_path(invitation_token: invited_submission.invitation_token)
    expect(invited_submission.reload.invitation_confirmed).to be true
    expect(page).to have_text('confirmed')
  end

  it "doesn't confirm submission with expired invitation token" do
    invited_submission = FactoryGirl.create(
      :submission,
      :with_rates,
      invitation_token: 'zzz',
      invitation_token_created_at: 1.week.ago - 1,
      invitation_confirmed: false,
      rates_num: setting.required_rates_num,
      rates_val: 1)

    visit submissions_confirm_path(invitation_token: invited_submission.invitation_token)
    expect(invited_submission.reload.invitation_confirmed).to be false
    expect(page).to have_text('expired')
  end

  it 'show correct info when invitation is already confirmed but token expired' do
    confirmed_submission = FactoryGirl.create(
      :submission,
      :with_rates,
      invitation_token: 'yyy',
      invitation_token_created_at: 1.week.ago - 1,
      invitation_confirmed: true,
      rates_num: setting.required_rates_num,
      rates_val: 1)

    visit submissions_confirm_path(invitation_token: confirmed_submission.invitation_token)
    expect(page).to have_text('confirmed')
  end

  context 'handling exceptions' do
    it 'missing invitation token' do
      visit submissions_confirm_path
      expect(page).to have_text('Something went wrong')
    end

    it 'submission not found' do
      visit submissions_confirm_path('uuu')
      expect(page).to have_text('Something went wrong')
    end
  end
end
