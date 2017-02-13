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
    visit submission_filters_results_path
    click_link('Send')
    click_link('Send')
    expect(ActionMailer::Base.deliveries.count).to eq(1)
    expect(accepted_submission.reload.invitation_token).not_to be_nil
  end
end
