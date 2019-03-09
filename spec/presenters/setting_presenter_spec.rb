require 'rails_helper'

RSpec.describe SettingPresenter do
  subject { described_class.new(setting) }
  let(:setting) { FactoryGirl.create(:setting, setting_params) }

  describe "#event_dates" do
    subject { described_class.new(setting).event_dates }

    context "when both dates are in the same month" do
      let(:setting_params) { { event_start_date: "2016-07-08", event_end_date: "2016-07-09" } }
      it { is_expected.to eq("8-9 July") }
    end

    context "when the dates aren't in the same month" do
      let(:setting_params) { { event_start_date: "2016-06-30", event_end_date: "2016-07-01" } }
      it { is_expected.to eq("30 June-1 July") }
    end
  end

  describe "#event_dates_with_year" do
    subject { described_class.new(setting).event_dates_with_year }

    let(:setting_params) { { event_start_date: "2016-07-08", event_end_date: "2016-07-09" } }

    it { is_expected.to eq("8-9 July 2016") }
  end

  describe "#event_url" do
    subject { described_class.new(setting).event_url }

    let(:setting_params) { { event_url: "railsgirls.com/lodz" } }

    it { is_expected.to eq("railsgirls.com/lodz") }
  end

  describe "#event_venue" do
    subject { described_class.new(setting).event_venue }

    let(:setting_params) { { event_venue: "krakow" } }

    it { is_expected.to eq("krakow") }
  end
end
