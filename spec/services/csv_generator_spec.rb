require 'rails_helper'

describe CsvGenerator do
  describe '#call' do
    subject { described_class.new.call(submissions, filename) }

    let!(:submissions) { FactoryBot.build_list(:submission, 2) }
    let!(:filename) { 'submissions.csv' }

    it { expect(subject.file).to include submissions.first.email }
  end
end
