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
      confirmation_status: 'not_available',
      rates_num: setting.required_rates_num,
      rates_val: 1)

    login_as(user, scope: :user)
    visit submissions_results_path
    click_link('Send')
    click_link('Send')
    expect(ActionMailer::Base.deliveries.count).to eq(1)
    expect(accepted_submission.reload).to be_awaiting
  end

  it 'confirms submission' do
    invited_submission = FactoryGirl.create(
      :submission,
      :with_rates,
      confirmation_status: 'awaiting',
      confirmation_token: 'xxx',
      confirmation_token_created_at: Time.now,
      rates_num: setting.required_rates_num,
      rates_val: 1)

    visit submissions_confirm_path(confirmation_token: invited_submission.confirmation_token)
    expect(invited_submission.reload).to be_confirmed
    expect(page).to have_text('confirmed')
  end

  it "doesn't confirm submission with expired confirmation token" do
    invited_submission = FactoryGirl.create(
      :submission,
      :with_rates,
      confirmation_status: 'awaiting',
      confirmation_token: 'zzz',
      confirmation_token_created_at: 1.week.ago - 1,
      rates_num: setting.required_rates_num,
      rates_val: 1)

    visit submissions_confirm_path(confirmation_token: invited_submission.confirmation_token)
    expect(invited_submission.reload).not_to be_confirmed
    expect(page).to have_text('expired')
  end

  it 'show correct info when invitation is already confirmed but token expired' do
    confirmed_submission = FactoryGirl.create(
      :submission,
      :with_rates,
      confirmation_status: 'confirmed',
      confirmation_token: 'yyy',
      confirmation_token_created_at: 1.week.ago - 1,
      rates_num: setting.required_rates_num,
      rates_val: 1)

    visit submissions_confirm_path(confirmation_token: confirmed_submission.confirmation_token)
    expect(page).to have_text('confirmed')
  end

  context 'handling exceptions' do
    it 'missing confirmation token' do
      visit submissions_confirm_path
      expect(page).to have_text('Something went wrong')
    end

    it 'submission not found' do
      visit submissions_confirm_path('uuu')
      expect(page).to have_text('Something went wrong')
    end
  end
end
