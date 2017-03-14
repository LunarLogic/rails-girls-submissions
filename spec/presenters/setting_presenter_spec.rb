require 'rails_helper'

RSpec.describe SettingPresenter do
  subject { described_class.new(setting) }
  let(:setting) { FactoryGirl.create(:setting, setting_params) }

  describe "#event_dates" do
    subject { described_class.new(setting).event_dates }

    context "when both dates are in the same month" do
      let(:setting_params) { { event_start_date: "2016-07-09", event_end_date: "2016-07-10" } }
      it { is_expected.to eq("9-10 July") }
    end

    context "when the dates aren't in the same month" do
      let(:setting_params) { { event_start_date: "2016-06-30", event_end_date: "2016-07-01" } }
      it { is_expected.to eq("30 June-01 July") }
    end
  end

  describe "#event_url" do
    subject { described_class.new(setting).event_url }

    let(:setting_params) { { event_url: "railsgirls.com/lodz" } }

    it { is_expected.to eq("railsgirls.com/lodz") }
  end
end
