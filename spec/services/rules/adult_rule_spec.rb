require 'rails_helper'

describe Rules::AdultRule do
  describe '#broken?' do
    subject { described_class.new.broken?(submission) }

    context 'when the applicant is underage' do
      let(:submission) { FactoryBot.create(:submission, adult: false) }

      it { is_expected.to equal(true) }
    end

    context 'when the applicant is adult' do
      let(:submission) { FactoryBot.create(:submission, adult: true) }

      it { is_expected.to equal(false) }
    end
  end
end
