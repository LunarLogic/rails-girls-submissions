require 'rails_helper'

describe CsvGenerator do
  describe '#call' do
    subject { described_class.new.call(submissions, filename).file }

    let!(:submissions) { FactoryBot.build_list(:submission, 2) }
    let!(:filename) { 'submissions.csv' }

    it { is_expected.to include submissions.first.email }
  end
end
