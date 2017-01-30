require 'rails_helper'

describe 'sending invitation emails to accepted submissions' do
  let(:setting) { FactoryGirl.build(:setting, available_spots: 2) }
  let!(:user) { FactoryGirl.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
    allow(Setting).to receive(:get).and_return(setting)
  end

  it 'sends one email to every accepted submission' do
    accepted_submissions = FactoryGirl.create_list(:submission, 2,
                                                   :with_rates,
                                                   confirmation_status: 'not_avaible',
                                                   rates_num: setting.required_rates_num,
                                                   rates_val: 1)
    login_as(user, scope: :user)
    visit submissions_results_path
    click_link('Send')
    click_link('Send')
    expect(accepted_submissions[0].reload.confirmation_status).to eq 'awaiting'
    expect(accepted_submissions[1].reload.confirmation_status).to eq 'awaiting'
    expect(ActionMailer::Base.deliveries.count).to eq(2)
  end
end
