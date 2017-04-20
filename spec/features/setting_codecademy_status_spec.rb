require "rails_helper"

describe "setting CodeCademy course completeness status" do
  let(:submission) { FactoryGirl.create(:submission, codecademy_status: codecademy_status) }
  let(:user) { FactoryGirl.create(:user) }

  let(:completed_text) { "Course completed" }
  let(:not_completed_text) { "Course not completed" }
  let(:completed_button) { "Completed" }
  let(:not_completed_button) { "Not completed" }

  before do
    login_as(user, scope: :user)
    visit submission_path(:valid, submission)
  end

  context "there is a completed status set" do
    let(:codecademy_status) { true }
    it { expect(page).to have_text(completed_text) }
  end

  context "there is a incompleted status set" do
    let(:codecademy_status) { false }
    it { expect(page).to have_text(not_completed_text) }
  end

  context "there is no status set" do
    let(:codecademy_status) { nil }

    it "has two buttons instead" do
      expect(page).not_to have_text(completed_text)
      expect(page).not_to have_text(not_completed_text)
      expect(page).to have_button(completed_button)
      expect(page).to have_button(not_completed_button)
    end

    it "changes status to completed on clicking completed button" do
      click_button(completed_button)
      expect(page).to have_text(completed_text)
      expect(page).not_to have_button(completed_button)
      expect(page).not_to have_button(not_completed_button)
    end

    it "changes status to incompleted on clicking incompleted button" do
      click_button(not_completed_button)
      expect(page).to have_text(not_completed_text)
      expect(page).not_to have_button(not_completed_button)
      expect(page).not_to have_button(completed_button)
    end
  end
end
