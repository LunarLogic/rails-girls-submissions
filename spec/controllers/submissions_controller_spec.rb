require "rails_helper"

RSpec.describe SubmissionsController, type: :controller do
  describe "GET #new" do
    subject { get :new }
    let!(:settings) do
      FactoryGirl.create(:setting, beginning_of_preparation_period: "2016-06-23 17:20:53 +0200",
                                   beginning_of_registration_period: "2016-06-24 17:20:53 +0200", beginning_of_closed_period: "2016-06-25 17:20:53 +0200")
    end

    context "current date falls during the preparation period" do
      it "renders RailsGirls coming soon template" do
        Timecop.travel(Time.zone.parse("2016-06-23 17:20:53 +0200")) do
          expect(subject).to render_template(:preparation)
        end
      end
    end

    context "current date falls during the registration period" do
      it "renders registration form" do
        # allow(Time).to receive(:now).and_return("2016-06-24 17:20:53 +0200")
        Timecop.travel(Time.zone.parse("2016-06-24 17:20:53 +0200")) do
          expect(subject).to render_template(:new)
        end
      end
    end

    context "current date falls during the closed period" do
      it "renders registraton closed template" do
        # allow(Time).to receive(:now).and_return("2016-06-25 17:20:53 +0200")
        Timecop.travel(Time.zone.parse("2016-06-25 17:20:53 +0200")) do
          expect(subject).to render_template(:closed)
        end
      end
    end
  end

  describe "POST #create" do
    subject { post :create, submission: submission_attributes }

    context "with vaild submission parameters" do
      let(:submission_attributes) do
        FactoryGirl.attributes_for(:submission)
      end

      it "redirects to thank you page" do
        expect(subject).to redirect_to("/submissions/thank_you")
      end

      it "saves the new submission" do
        expect{ subject }.to change(Submission, :count).by(1)
      end
    end

    context "with invaild submission parameters" do
      let(:submission_attributes) do
        { full_name: "NN", email: "nn" }
      end

      it "shows form again" do
        expect(subject).to render_template(:new)
      end

      it "does not save the new submission" do
        expect{ subject }.not_to change(Submission, :count)
      end
    end
  end

  describe "GET #show" do
    let(:submission) { FactoryGirl.create(:submission) }

    before { sign_in(FactoryGirl.create(:user)) }

    it "renders 404 if an invalid submission filter is typed in the path" do
      get :show, filter: :invalid_filter, id: submission.id
      expect(response).to have_http_status(404)
    end

    it "redirects to index for a given filter if the submission doesn't belong to the filter" do
      get :show, filter: :rated, id: submission.id
      expect(response).to have_http_status(404)
    end
  end
end
