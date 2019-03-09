require "rails_helper"

describe "testing updating settings:" do
  before do
    FactoryGirl.create(:setting)
    login_as(FactoryGirl.create(:user), scope: :user)
    visit settings_path

    find("#setting_available_spots").set(5)
    find("#setting_required_rates_num").set(5)
    find("#setting_days_to_confirm_invitation").set(7)
    find("#setting_beginning_of_preparation_period").set("2016/06/21")
    find("#setting_beginning_of_registration_period").set("2016/06/22")
    find("#setting_end_of_registration_period").set("2016/06/22")
    find("#setting_event_venue").set("krakow")

    click_button "Save settings"
  end

  it "moves to settings view, fills in the form fields, clicks save, checks if settings got updated" do
    expect(Setting.get.available_spots).to eq(5)
    expect(Setting.get.required_rates_num).to eq(5)
    expect(Setting.get.days_to_confirm_invitation).to eq(7)
    expect(Setting.get.beginning_of_preparation_period).to eq("Thu, 21 Jun 2016 00:00:00 CEST +02:00")
    expect(Setting.get.beginning_of_registration_period).to eq("Thu, 22 Jun 2016 00:00:00 CEST +02:00")
    expect(Setting.get.beginning_of_closed_period).to eq("Thu, 23 Jun 2016 00:00:00 CEST +02:00")
    expect(Setting.get.event_venue).to eq("krakow")
  end
end
