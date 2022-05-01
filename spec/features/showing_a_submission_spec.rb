require "rails_helper"

describe "showing a submission" do
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
    expect(current_path).to eq submission_path(filter, submission.id)
    click_link('Back', class: 'link-return')
    expect(current_path).to eq filtered_submissions_path
  end
end
