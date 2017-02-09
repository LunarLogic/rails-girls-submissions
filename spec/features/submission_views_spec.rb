require "rails_helper"

describe "testing submissions views:" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    setting = FactoryGirl.create(:setting)
    FactoryGirl.create(:submission, full_name: "Applicant To Rate")
    FactoryGirl.create(:submission, :with_rates, rates_num: setting.required_rates_num,
      full_name: "Applicant Rated")
    FactoryGirl.create(:submission, rejected: true, full_name: "Applicant Rejected")
    FactoryGirl.create(
      :submission,
      :with_rates,
      invitation_confirmed: true,
      full_name: "Applicant Confirmed Invitation")

    login_as(user, scope: :user)
    visit admin_path
  end

  it "moves to valid view" do
    click_link "Valid"
    expect(current_path).to eq submission_filters_valid_path
    expect(page).to have_selector('td', text: "Applicant To Rate")
    expect(page).to have_selector('td', text: "Applicant Rated")
  end

  it "moves to rejected view" do
    click_link "Rejected"
    expect(current_path).to eq submission_filters_rejected_path
    expect(page).to have_selector('td', text: "Applicant Rejected")
  end

  it "moves to to_rate view" do
    click_link "To rate"
    expect(current_path).to eq submission_filters_to_rate_path
    expect(page).to have_selector('td', text: "Applicant To Rate")
  end

  it "moves to results view" do
    click_link "Results"
    expect(current_path).to eq submission_filters_results_path
    expect(page).to have_selector('td', text: "Applicant Rated")
  end

  it "moves to invitations view" do
    click_link "Invitations"
    expect(current_path).to eq submission_filters_invitations_path
    expect(page).to have_selector('td', text: "Applicant Confirmed Invitation")
  end
end
