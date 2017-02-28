require "rails_helper"

describe "the commenting process" do
  let(:submission) { FactoryGirl.create(:submission) }
  let(:user) { FactoryGirl.create(:user) }
  let(:comment_body) { 'lalala' }
  let(:invalid_comment_body) { 'lalala' * 100 }

  before do
    login_as(user, scope: :user)
    visit submission_path(:valid, submission)
  end

  it "inserts valid comment, displays the comment" do
    fill_in 'comment_body', with: comment_body
    click_button('Comment')
    expect(page).to have_text(comment_body)
  end

  it "inserts invalid comment, doesn't display the comment" do
    fill_in 'comment_body', with: invalid_comment_body
    click_button('Comment')
    expect(page).not_to have_text(comment_body)
  end
end
