require "rails_helper"

describe "managing questions" do
  before do
    login_as(FactoryGirl.create(:user), scope: :user)
  end

  it "lists all questions" do
    count = 3
    FactoryGirl.create_list(:question, count)

    visit admin_path
    click_button "Questions Creator"
    expect(current_path).to eq questions_path
    expect(page).to have_selector(".question-list-item", count: count)
  end

  it "creates a new question" do
    visit questions_path

    text = "question's text"
    fill_in "Add a new question", with: text
    click_button('Create')
    expect(current_path).to eq questions_path
    expect(page).to have_text(text)
  end

  it "deletes a question" do
    FactoryGirl.create(:question)

    visit questions_path
    click_link('Remove')
    expect(current_path).to eq questions_path
    expect(page).not_to have_selector(".question-list-item")
  end
end
