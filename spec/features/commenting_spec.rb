require "rails_helper"

describe "the commenting process" do
  let!(:submission) { FactoryGirl.create(:submission) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:comment_body) { 'lalala' }

  it "visits submission page, creates comment, checks if comment is being displayed" do
    login_as(user, scope: :user)
    visit submission_path(submission)
    fill_in 'comment_body', with: comment_body
    click_button('Comment')
    expect(page).to have_text(comment_body)
  end
end
