require "rails_helper"

# "js: true" switches Capybara's driver to javascript_driver, which is :selenium by default
describe "the rating process", js: true do
  let!(:submission) { FactoryGirl.create(:submission) }
  let!(:user) { FactoryGirl.create(:user) }

  it "visits submission page, finds and clicks rate button" do
    login_as(user, scope: :user)
    visit submission_path(:valid, submission)

    label = page.find("label[for='value_5']")
    expect{ label.click }.to change(submission.rates, :count).by(1)
  end
end
