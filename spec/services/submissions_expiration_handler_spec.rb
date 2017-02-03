require 'rails_helper'

RSpec.describe SubmissionsExpirationHandler do
  describe '#call' do
    let(:submissions_inviter) { SubmissionsInviter.new }
    let(:submissions_expirer) { SubmissionsExpirer.new }

    subject do
      described_class.new(submissions_inviter: submissions_inviter, submissions_expirer: submissions_expirer).call
    end

    it 'calls proper services' do
      expect(submissions_inviter).to receive(:call)
      expect(submissions_expirer).to receive(:call)
      subject
    end
  end
end
