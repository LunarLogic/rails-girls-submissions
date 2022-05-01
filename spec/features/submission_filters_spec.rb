require "rails_helper"

describe "testing submissions filters", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:setting) { FactoryBot.create(:setting) }

  context "when there are submissions to show" do
    before do
      FactoryBot.create(:submission, full_name: "Applicant To Rate")
      FactoryBot.create(:submission, :with_rates, rates_num: setting.required_rates_num, full_name: "Applicant Rated")
      FactoryBot.create(:submission, rejected: true, full_name: "Applicant Rejected")
      FactoryBot.create(
        :submission,
        :with_rates,
        invitation_confirmed: true,
        full_name: "Applicant Confirmed Invitation"
      )

      login_as(user, scope: :user)
      visit admin_path
    end

    it "moves to valid filter" do
      click_link "Valid"
      expect(page).to have_current_path submissions_valid_path, ignore_query: true
      expect(page).to have_selector('td', text: "Applicant To Rate")
      expect(page).to have_selector('td', text: "Applicant Rated")
    end

    it "moves to rejected filter" do
      click_link "Rejected"
      expect(page).to have_current_path submissions_rejected_path, ignore_query: true
      expect(page).to have_selector('td', text: "Applicant Rejected")
    end

    it "moves to to_rate filter" do
      click_link "To rate"
      expect(page).to have_current_path submissions_to_rate_path, ignore_query: true
      expect(page).to have_selector('td', text: "Applicant To Rate")
    end

    it "moves to results filter" do
      click_link "Results"
      expect(page).to have_current_path submissions_results_path, ignore_query: true
      expect(page).to have_selector('td', text: "Applicant Rated")
    end

    it "moves to participants filter" do
      click_link "Participants"
      expect(page).to have_current_path submissions_participants_path, ignore_query: true
      expect(page).to have_selector('td', text: "Applicant Confirmed Invitation")
    end
  end

  context "when there are no submissions to show" do
    before do
      FactoryBot.create(:submission, full_name: "Applicant To Rate")
      login_as(user, scope: :user)
      visit admin_path
    end

    it "moves to a filter and shows a message" do
      click_link "Results"
      expect(page).to have_current_path submissions_results_path, ignore_query: true
      expect(page).not_to have_selector('td', text: "Applicant To Rate")
      expect(page).to have_text('No rated submissions to show')
    end
  end
end
