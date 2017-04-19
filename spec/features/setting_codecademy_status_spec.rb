require "rails_helper"

describe "setting CodeCademy course completeness status" do
  let(:submission) { FactoryGirl.create(:submission, codecademy_status: codecademy_status) }
  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user, scope: :user)
    visit submission_path(:valid, submission)
  end

  context "there is a completed status set" do
    let(:codecademy_status) { true }
    it { expect(page).to have_text("Completed") }
  end

  context "there is a incompleted status set" do
    let(:codecademy_status) { false }
    it { expect(page).to have_text("Incompleted") }
  end

  context "there is no status set" do
    let(:codecademy_status) { nil }

    it "has two buttons instead" do
      expect(page).not_to have_text("Completed")
      expect(page).not_to have_text("Incompleted")
      expect(page).to have_button("Completed")
      expect(page).to have_button("Incompleted")
    end

    it "changes status to completed on clicking completed button" do
      click_button("Completed")
      expect(page).to have_text("Completed")
      expect(page).not_to have_button("Completed")
      expect(page).not_to have_button("Incompleted")
    end

    it "changes status to incompleted on clicking incompleted button" do
      click_button("Incompleted")
      expect(page).to have_text("Incompleted")
      expect(page).not_to have_button("Incompleted")
      expect(page).not_to have_button("Completed")
    end
  end
end
