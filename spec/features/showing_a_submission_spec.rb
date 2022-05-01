require "rails_helper"

describe "showing a submission", type: :feature do
  let!(:submission) { FactoryBot.create(:submission) }
  let(:user) { FactoryBot.create(:user) }

  let(:filter) { :valid }
  let(:filtered_submissions_path) { "/admin/submissions/#{filter}" }

  before do
    login_as(user, scope: :user)
    visit filtered_submissions_path
  end

  it "shows a submission and goes back to the list view" do
    click_link('Show')
    expect(page).to have_current_path submission_path(filter, submission.id), ignore_query: true
    click_link('Back', class: 'link-return')
    expect(page).to have_current_path filtered_submissions_path, ignore_query: true
  end
end
