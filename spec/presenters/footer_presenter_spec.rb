require 'rails_helper'

RSpec.describe FooterPresenter do
  let!(:setting) do
    FactoryGirl.create(:setting,
      event_start_date: "2016-07-09",
      event_end_date: "2016-07-10",
      event_url: "railsgirls.com/lodz"
    )
  end

  subject { described_class.new(setting) }

  it 'presents event dates' do
    expect(subject.event_dates).to eq('9-10 July')
  end

  it 'presents url to event' do
    expect(subject.event_url).to eq('railsgirls.com/lodz')
  end
end
