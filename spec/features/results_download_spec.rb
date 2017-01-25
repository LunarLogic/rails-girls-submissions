require 'rails_helper'

describe "csv downloading process" do
  let!(:user)    { FactoryGirl.create(:user) }
  let!(:setting) { FactoryGirl.create(:setting, available_spots: 1) }
  let!(:accepted_submissiom) { FactoryGirl.create(:submission, :with_rates,
    rates_num: setting.required_rates_num) }

  it "visits results page, clicks 'Accepted', checks if csv file is downloaded" do
    login_as(user, scope: :user)
    visit submissions_results_path
    click_link('Accepted')
    expect(response_headers["Content-Type"]).to eq("text/csv")
    expect(response_headers["Content-Disposition"]).to eq("attachment; filename=\"accepted.csv\"")
  end

  it "visits results page, clicks 'Waitlist', checks if csv file is downloaded" do
    login_as(user, scope: :user)
    visit submissions_results_path
    expect(page).to have_selector('li', text: 'Waitlist')
  end
end
