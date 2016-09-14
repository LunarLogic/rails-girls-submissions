require 'rails_helper'

RSpec.describe FooterPresenter do
  let!(:setting) { FactoryGirl.create(:setting) }
  subject { described_class.new(setting) }

  it 'presents event dates' do
    expect(subject.event_dates).to eq('16-17 April')
  end

  it 'presents url to event' do
    expect(subject.event_url).to eq('railsgirls.com/krakow')
  end
end
