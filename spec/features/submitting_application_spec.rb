require "rails_helper"

RSpec::Matchers.define_negated_matcher :not_change, :change

describe "user submits their railsgirls application", type: :feature do
  before do
    allow(Setting).to receive(:registration_period?).and_return(true)
    FactoryBot.create(:question)

    visit root_path

    fill_in :submission_full_name, with: "full name"
    fill_in :submission_email, with: "email@email.com"
    fill_in :submission_gender, with: "nb"
    check :submission_adult
    fill_in :submission_description, with: "description"
    choose :submission_english_fluent
    choose :submission_operating_system_mac
    check :submission_first_time
    fill_in :submission_goals, with: "goals"
  end

  let(:action) { click_on "Apply for workshop" }

  it "creates a new submission" do
    choose :submission_answers_attributes_0_choice_well

    expect { action }.to change(Answer, :count).by(1).and change(Submission, :count).by(1)
    expect(page).to have_current_path submissions_thank_you_path, ignore_query: true
  end

  it "doesn't create a submission unless all answers are present" do
    expect { action }.to not_change(Answer, :count).and not_change(Submission, :count)
    expect(page).to have_no_current_path submissions_thank_you_path, ignore_query: true
    expect(page).to have_text('Your submission needs to be corrected')
  end
end
