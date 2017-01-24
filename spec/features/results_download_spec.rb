describe "csv downloading process" do
  let!(:user) { FactoryGirl.create(:user) }

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
    click_link('Waitlist')
    expect(response_headers["Content-Type"]).to eq("text/csv")
    expect(response_headers["Content-Disposition"]).to eq("attachment; filename=\"waitlist.csv\"")
  end
end
