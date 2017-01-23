describe "testing submissions views:" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    setting = FactoryGirl.create(:setting)
    FactoryGirl.create(:submission, full_name: "Applicant To Rate")
    FactoryGirl.create(:submission, :with_rates, rates_num: setting.required_rates_num,
      full_name: "Applicant Rated")
    FactoryGirl.create(:submission, rejected: true, full_name: "Applicant Rejected")
  end

  it "moves to to_rate view" do
    login_as(user, scope: :user)
    visit submissions_path
    click_link "To rate"
    expect(current_path).to eq submissions_to_rate_path
    expect(page).to have_selector('td', text: "Applicant To Rate")
  end

  it "moves to rated view" do
    login_as(user, scope: :user)
    visit submissions_path
    click_link "Rated"
    expect(current_path).to eq submissions_rated_path
    expect(page).to have_selector('td', text: "Applicant Rated")
  end

  it "moves to rejected view" do
    login_as(user, scope: :user)
    visit submissions_path
    click_link "Rejected"
    expect(current_path).to eq submissions_rejected_path
    expect(page).to have_selector('td', text: "Applicant Rejected")
  end
end
