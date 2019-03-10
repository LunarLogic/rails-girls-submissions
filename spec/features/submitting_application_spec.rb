require "rails_helper"

RSpec::Matchers.define_negated_matcher :not_change, :change

describe "user submits their railsgirls application" do
  before do
    allow(Setting).to receive(:registration_period?).and_return(true)
    FactoryGirl.create(:question)

    visit root_path

    fill_in :submission_full_name, with: "full name"
    fill_in :submission_email, with: "email@email.com"
    fill_in :submission_age, with: "18"
    fill_in :submission_description, with: "description"
    choose :submission_english_fluent
    choose :submission_operating_system_mac
    check :submission_first_time
    fill_in :submission_goals, with: "goals"
  end

  let(:action) { click_on "Apply for workshop" }

  it "creates a new submission" do
    choose :"submission_answers_attributes_0_value_well"

    expect { action }.to change(Answer, :count).by(1).and change(Submission, :count).by(1)
    expect(current_path).to eq submissions_thank_you_path
  end

  it "doesn't create a submission unless all answers are present" do
    expect { action }.to not_change(Answer, :count).and not_change(Submission, :count)
    expect(current_path).not_to eq submissions_thank_you_path
  end
end
