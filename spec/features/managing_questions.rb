require "rails_helper"

describe "managing questions" do
  before do
    login_as(FactoryGirl.create(:user), scope: :user)
    visit questions_path
  end

  it "creates a new radio button question" do
    expect(current_path).to eq questions_path

    click_link "Add a radio button question"
    expect(current_path).to eq new_question_path

    text = "text"
    fill_in "Question's text", with: text
    click_button('Create')
    expect(current_path).to eq questions_path
    expect(page).to have_text(text)
  end
end
