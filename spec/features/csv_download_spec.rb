require 'rails_helper'

describe "csv downloading process" do
  let(:user)    { FactoryGirl.create(:user) }
  let(:setting) { FactoryGirl.create(:setting, available_spots: 1, required_rates_num: 1) }

  context "when submissions exist" do
    before do
      allow(Setting).to receive(:get).and_return(setting)
      FactoryGirl.create(:submission, :with_rates,
                         rates_num: setting.required_rates_num,
                         rates_val: 3,
                         invitation_confirmed: true)
    end

    it "visits participants page, clicks 'Download', checks if csv file is downloaded" do
      login_as(user, scope: :user)
      visit submissions_participants_path
      click_link('Download')
      expect(response_headers["Content-Type"]).to eq("text/csv")
      expect(response_headers["Content-Disposition"]).to eq("attachment; filename=\"participants.csv\"")
    end
  end

  context "when submissions don't exist" do
    it "There is no download button" do
      login_as(user, scope: :user)
      visit submissions_participants_path
      expect(page).not_to have_selector('a', text: 'Download')
    end
  end
end
