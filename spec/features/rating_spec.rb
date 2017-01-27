require "rails_helper"

describe "the rating process" do
  let!(:submission) { FactoryGirl.create(:submission) }
  let!(:user) { FactoryGirl.create(:user) }

  it "visits submission page, finds and clicks rate button" do
    login_as(user, scope: :user)
    visit submission_path(submission)
    choose("value_4")
    expect{ click_button 'Rate!' }.to change(submission.rates, :count).by(1)
  end
end
