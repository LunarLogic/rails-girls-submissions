require 'rails_helper'

describe SubmissionsExpirer do
  describe '#call' do
    let(:submission_repository) { SubmissionRepository.new }
    let(:submissions) { [submission_1, submission_2] }
    let(:submission_1) { instance_double Submission }
    let(:submission_2) { instance_double Submission }
    subject { described_class.new(submission_repository: submission_repository).call }

    it 'expires correct submissions' do
      expect(submission_repository).to receive(:to_expire).and_return(submissions)
      expect(submissions).to all(receive(:expired!))
      subject
    end
  end
end
