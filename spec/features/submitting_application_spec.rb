require "rails_helper"

describe "user submits their railsgirls application" do
  before do
    allow(Setting).to receive(:registration_period?).and_return(true)
    FactoryGirl.create(:question)
  end

  let(:action) { click_on "Apply for workshop" }

  it "creates a new submission" do
    visit root_path

    fill_in :submission_full_name, with: "full name"
    fill_in :submission_email, with: "email@email.com"
    fill_in :submission_age, with: "18"
    fill_in :submission_codecademy_username, with: "username"
    fill_in :submission_description, with: "description"

    # will be refactored after the skills are replaced with questions
    Submission::SKILLS.each do |skill|
      choose :"submission_#{skill}_used"
    end

    choose :"submission_answers_attributes_0_value_well"

    choose :submission_english_fluent
    choose :submission_operating_system_mac
    check :submission_first_time
    fill_in :submission_goals, with: "goals"

    expect { action }.to change(Answer, :count).by(1).and change(Submission, :count).by(1)
    expect(current_path).to eq submissions_thank_you_path
  end
end
