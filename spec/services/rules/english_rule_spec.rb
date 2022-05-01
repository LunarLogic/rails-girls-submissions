require 'rails_helper'

describe Rules::EnglishRule do
  describe '#broken?' do
    subject { described_class.new.broken?(submission) }

    context "when the applicant doesn't know English at all" do
      let!(:submission) { FactoryBot.create(:submission, english: "none") }
      it { expect(subject).to equal(true) }
    end

    context "when the applicant speaks English" do
      let!(:submission) { FactoryBot.create(:submission, english: "fluent") }
      it { expect(subject).to equal(false) }
    end
  end
end
