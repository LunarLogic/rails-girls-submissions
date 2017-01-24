require "rails_helper"

describe "testing updating settings:" do
  before do
    FactoryGirl.create(:setting)
    login_as(FactoryGirl.create(:user), scope: :user)
    visit settings_path
    fill_in 'Available spots', with: 5
    fill_in 'Required rates num', with: 5
    fill_in 'Beginning of preparation period', with: "2016/06/21"
    fill_in 'Beginning of registration period', with: "2016/06/22"
    fill_in 'Beginning of closed period', with: "2016/06/23"
    click_button "Save settings"
  end

  it "moves to settings view, fills in the form fields, clicks save, checks if settings got updated" do
    expect(Setting.get.available_spots).to eq(5)
    expect(Setting.get.required_rates_num).to eq(5)
    expect(Setting.get.beginning_of_preparation_period).to eq("Thu, 21 Jun 2016 00:00:00 CEST +02:00")
    expect(Setting.get.beginning_of_registration_period).to eq("Thu, 22 Jun 2016 00:00:00 CEST +02:00")
    expect(Setting.get.beginning_of_closed_period).to eq("Thu, 23 Jun 2016 00:00:00 CEST +02:00")
  end
end
