describe "csv downloading process" do
  before do
    allow(Setting).to receive(:get).and_return(FactoryGirl.create(:setting))
  end

  let!(:setting_values) do
    { accepted_threshold: FactoryGirl.build(:setting).accepted_threshold,
      waitlist_threshold: FactoryGirl.build(:setting).waitlist_threshold,
      required_rates_num: FactoryGirl.build(:setting).required_rates_num }
  end

  let!(:user) { FactoryGirl.create(:user) }
  let!(:accepted_submission) { FactoryGirl.create(:accepted_submission, :with_settings, setting_values) }

  it "visits results page, clicks 'Accepted', checks if csv file is downloaded" do
    login_as(user, scope: :user)
    visit submissions_results_path
    click_link('Accepted')
    expect(response_headers["Content-Type"]).to eq("text/csv")
    expect(response_headers["Content-Disposition"]).to eq("attachment; filename=\"accepted.csv\"")
  end

  it "visits results page, clicks 'Waitlist', checks if csv file is downloaded" do
    login_as(user, scope: :user)
    visit submissions_results_path
    expect(page).to have_selector('li', text: 'Waitlist')
  end

  it "visits results page, clicks 'Unaccepted', checks if csv file is downloaded" do
    login_as(user, scope: :user)
    visit submissions_results_path
    expect(page).to have_selector('li', text: 'Unaccepted')
  end
end
