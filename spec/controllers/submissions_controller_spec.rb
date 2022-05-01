require "rails_helper"

RSpec.describe SubmissionsController, type: :controller do
  describe "GET #new" do
    subject(:new) { get :new }

    let!(:settings) do # rubocop:disable RSpec/LetSetup
      FactoryBot.create(
        :setting,
        beginning_of_preparation_period: "2016-06-23 17:20:53 +0200",
        beginning_of_registration_period: "2016-06-24 17:20:53 +0200",
        beginning_of_closed_period: "2016-06-25 17:20:53 +0200"
      )
    end

    context "when current date falls during the preparation period" do
      it "renders RailsGirls coming soon template" do
        Timecop.travel(Time.zone.parse("2016-06-23 17:20:53 +0200")) do
          expect(new).to render_template(:preparation)
        end
      end
    end

    context "when current date falls during the registration period" do
      it "renders registration form" do
        # allow(Time).to receive(:now).and_return("2016-06-24 17:20:53 +0200")
        Timecop.travel(Time.zone.parse("2016-06-24 17:20:53 +0200")) do
          expect(new).to render_template(:new)
        end
      end
    end

    context "when current date falls during the closed period" do
      it "renders registraton closed template" do
        # allow(Time).to receive(:now).and_return("2016-06-25 17:20:53 +0200")
        Timecop.travel(Time.zone.parse("2016-06-25 17:20:53 +0200")) do
          expect(new).to render_template(:closed)
        end
      end
    end
  end

  describe "POST #create" do
    subject(:create) { post :create, params: { submission: submission_attributes } }

    context "with vaild submission parameters" do
      let(:submission_attributes) do
        FactoryBot.attributes_for(:submission)
      end

      it "redirects to thank you page" do
        expect(create).to redirect_to("/submissions/thank_you")
      end

      it "saves the new submission" do
        expect{ create }.to change(Submission, :count).by(1)
      end
    end

    context "with invaild submission parameters" do
      let(:submission_attributes) do
        { full_name: "NN", email: "nn" }
      end

      it "shows form again" do
        expect(create).to render_template(:new)
      end

      it "does not save the new submission" do
        expect{ create }.not_to change(Submission, :count)
      end
    end
  end

  describe "GET #show" do
    let(:submission) { FactoryBot.create(:submission) }

    before { sign_in(FactoryBot.create(:user)) }

    it "renders 404 if an invalid submission filter is typed in the path" do
      get :show, params: { filter: :invalid_filter, id: submission.id }
      expect(response).to have_http_status(:not_found)
    end

    it "redirects to index for a given filter if the submission doesn't belong to the filter" do
      get :show, params: { filter: :rated, id: submission.id }
      expect(response).to have_http_status(:not_found)
    end
  end
end
