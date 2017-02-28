require "rails_helper"

describe "testing submissions filters:" do
  let(:user) { FactoryGirl.create(:user) }
  let(:setting) { FactoryGirl.create(:setting) }

  context "when there are submissions to show" do
    before do
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

    it "moves to valid filter" do
      click_link "Valid"
      expect(current_path).to eq submission_filters_valid_path
      expect(page).to have_selector('td', text: "Applicant To Rate")
      expect(page).to have_selector('td', text: "Applicant Rated")
    end

    it "moves to rejected filter" do
      click_link "Rejected"
      expect(current_path).to eq submission_filters_rejected_path
      expect(page).to have_selector('td', text: "Applicant Rejected")
    end

    it "moves to to_rate filter" do
      click_link "To rate"
      expect(current_path).to eq submission_filters_to_rate_path
      expect(page).to have_selector('td', text: "Applicant To Rate")
    end

    it "moves to results filter" do
      click_link "Results"
      expect(current_path).to eq submission_filters_results_path
      expect(page).to have_selector('td', text: "Applicant Rated")
    end

    it "moves to invitations filter" do
      click_link "Invitations"
      expect(current_path).to eq submission_filters_invitations_path
      expect(page).to have_selector('td', text: "Applicant Confirmed Invitation")
    end
  end

  context "when there are no submissions to show" do
    before do
      FactoryGirl.create(:submission, full_name: "Applicant To Rate")
      login_as(user, scope: :user)
      visit admin_path
    end

    it "moves to a filter and shows a message" do
      click_link "Results"
      expect(current_path).to eq submission_filters_results_path
      expect(page).not_to have_selector('td', text: "Applicant To Rate")
      expect(page).to have_text('No rated submissions to show')
    end
  end
end
