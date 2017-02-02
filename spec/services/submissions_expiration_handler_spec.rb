require 'rails_helper'

RSpec.describe SubmissionsExpirationHandler do
  describe '#call' do
    let(:submission_repository) { SubmissionRepository.new }
    let(:submissions_inviter) { SubmissionsInviter.new }
    let(:setting) { FactoryGirl.build(:setting, available_spots: 3) }

    subject { described_class.new(submission_repository: submission_repository, submissions_inviter: submissions_inviter) }

    before { allow(Setting).to receive(:get).and_return(setting) }

    context 'when there are expired submissions' do
      let!(:confirmed_submission) do
        FactoryGirl.create(
          :submission,
          :with_rates,
          confirmation_token_created_at: 1.week.ago - 1,
          confirmation_status: 'confirmed',
          rates_num: setting.required_rates_num,
          rates_val: 4)
      end
      let!(:expired_submissions) do
        FactoryGirl.create_list(
          :submission, 2,
          :with_rates,
          confirmation_token_created_at: 1.week.ago - 1,
          confirmation_status: 'awaiting',
          rates_num: setting.required_rates_num,
          rates_val: 4)
      end

      before { expect(Submission).to receive(:select).and_return(expired_submissions) }

      it 'expires correct submissions' do
        subject.call
        expect(expired_submissions).to all(be_expired)
        expect(confirmed_submission).not_to be_expired
      end

      context 'when there are waitlist submissions' do
        let!(:to_invite_submissions) do
          FactoryGirl.create_list(
            :submission, 2,
            :with_rates,
            confirmation_status: nil,
            rates_num: setting.required_rates_num,
            rates_val: 2)
        end

        before { expect(submission_repository).to receive(:to_invite).and_return(to_invite_submissions) }

        it 'sends invitations to proper submissions' do
          expect(submissions_inviter).to receive(:invite).with(to_invite_submissions[0])
          expect(submissions_inviter).to receive(:invite).with(to_invite_submissions[1])

          subject.call
        end
      end

      context 'when there are no waitlist submissions' do
        it 'sends no emails' do
          expect(submissions_inviter).not_to receive(:invite)
          subject.call
        end
      end
    end

    context "when there are no expired submissions" do
      it 'sends no emails' do
        expect(submissions_inviter).not_to receive(:invite)
        subject.call
      end
    end
  end
end
