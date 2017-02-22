require "rails_helper"

# "js: true" switches Capybara's driver to :selenium which is a default driver for specs using js
describe "the rating process", js: true do
  let!(:submission) { FactoryGirl.create(:submission) }
  let!(:user) { FactoryGirl.create(:user) }

  it "visits submission page, finds and clicks rate button" do
    login_as(user, scope: :user)
    visit submission_path(submission)

    label = page.find("label[for='value_5']")
    expect{ label.click }.to change(submission.rates, :count).by(1)
  end
end
