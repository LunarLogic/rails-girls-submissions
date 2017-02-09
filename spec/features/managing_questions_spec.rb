require "rails_helper"

describe "managing questions" do
  before do
    login_as(FactoryGirl.create(:user), scope: :user)
  end

  it "lists all questions" do
    count = 3
    FactoryGirl.create_list(:question, count)

    visit questions_path
    expect(page).to have_selector(".rb-question", count: count)
  end

  it "creates a new question" do
    visit questions_path

    click_link "Add a radio button question"
    expect(current_path).to eq new_question_path

    text = "question's text"
    fill_in "Question's text", with: text
    click_button('Create')
    expect(current_path).to eq questions_path
    expect(page).to have_text(text)
  end

  it "deletes a question" do
    FactoryGirl.create(:question)

    visit questions_path
    click_link('Destroy')
    expect(current_path).to eq questions_path
    expect(page).not_to have_selector(".rb-question")
  end
end
