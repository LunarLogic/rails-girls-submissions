describe "printing submission's rates in submission show view" do
  let!(:submission) { FactoryGirl.create(:submission) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:setting) { FactoryGirl.create(:setting) }

  context "when the submission has required number of rates" do
    let!(:sample_rate) do
      submission.rates << FactoryGirl.build_list(:rate, setting.required_rates_num)
      submission.rates.sample
    end
    let!(:sample_rate_presenter) { RatePresenter.new(sample_rate, sample_rate.user) }
    let!(:sample_nickname) { sample_rate_presenter.user_nickname }
    let!(:sample_value) { sample_rate_presenter.value }
    let!(:rates_number) { submission.rates.size }

    it "shows rates in submission view" do
      login_as(user, scope: :user)
      visit submission_path(submission.id)

      expect(page).to have_css('div.submission-rate', count: rates_number)
      expect(page).to have_text("#{sample_nickname} rated #{sample_value}")
    end
  end

  context "when the submission does not have required number of rates" do
    it "does not show rates in submission view" do
      login_as(user, scope: :user)
      visit submission_path(submission.id)
      expect(page).to have_css('div.submission-rate', count: 0)
    end
  end
end
