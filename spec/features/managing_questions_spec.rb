require "rails_helper"

describe "managing questions", type: :feature do
  before do
    login_as(FactoryBot.create(:user), scope: :user)
  end

  it "lists all questions" do
    count = 3
    FactoryBot.create_list(:question, count)

    visit admin_path
    click_link "Questions"
    expect(page).to have_current_path questions_path, ignore_query: true
    expect(page).to have_selector(".question-list-item", count: count)
  end

  it "creates a new question" do
    visit questions_path

    text = "question's text"
    fill_in "Add a new question", with: text
    click_button('Create')
    expect(page).to have_current_path questions_path, ignore_query: true
    expect(page).to have_text(text)
  end

  it "deletes a question" do
    FactoryBot.create(:question)

    visit questions_path
    click_link('Remove')
    expect(page).to have_current_path questions_path, ignore_query: true
    expect(page).not_to have_selector(".question-list-item")
  end
end
