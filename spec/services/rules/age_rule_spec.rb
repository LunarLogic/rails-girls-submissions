require 'rails_helper'

describe Rules::AgeRule do
  describe '#broken?' do
    subject { described_class.new.broken?(submission) }

    context 'when the applicant is underage' do
      let(:submission) { FactoryGirl.create(:submission, age: 15) }
      it { expect(subject).to equal(true) }
    end

    context 'when the applicant is an adult' do
      let(:submission) { FactoryGirl.create(:submission, age: 18) }
      it { expect(subject).to equal(false) }
    end
  end
end
