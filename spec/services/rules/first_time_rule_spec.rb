require 'rails_helper'

describe Rules::FirstTimeRule do
  describe '#broken?' do
    subject { described_class.new.broken?(submission) }

    context 'when the applicant has attended the event before' do
      let!(:submission) { FactoryBot.create(:submission, first_time: false) }
      it { expect(subject).to equal(true) }
    end

    context 'when the applicant has never attended the event' do
      let!(:submission) { FactoryBot.create(:submission, first_time: true) }
      it { expect(subject).to equal(false) }
    end
  end
end
