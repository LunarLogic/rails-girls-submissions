require 'rails_helper'

RSpec.describe WaitingSubmissionsAcceptor do
  describe '#call' do
    let(:submission_repository) { SubmissionRepository.new }
    let(:setting) { FactoryGirl.build(:setting, available_spots: 3) }

    subject { described_class.new(submission_repository) }

    before { allow(Setting).to receive(:get).and_return(setting) }

    context 'when there are expired submissions' do
      let!(:confirmed_submission) do
         FactoryGirl.create(:submission,
                                 :with_rates,
                                 confirmation_token_created_at: 1.week.ago - 1,
                                 confirmation_status: 'confirmed',
                                 rates_num: setting.required_rates_num,
                                 rates_val: 4)
      end
      let!(:expired_submissions) do
         FactoryGirl.create_list(:submission, 2,
                                 :with_rates,
                                 confirmation_token_created_at: 1.week.ago - 1,
                                 confirmation_status: 'awaiting',
                                 rates_num: setting.required_rates_num,
                                 rates_val: 4)
      end

      before do
        expect(Submission).to receive(:select).and_return(expired_submissions)
      end

      it 'expires correct submissions' do
        subject.call
        expect(expired_submissions).to all(be_expired)
        expect(confirmed_submission).to be_confirmed
      end

      context 'when there are waitlist submissions' do
        let(:waitlist_submissions) do
          [waitlist_submissions_to_be_accepted,
           waitlist_submission_over_the_limit,
           waitlist_submission_that_already_has_confirmation_link]
        end

        let(:waitlist_submissions_without_confirmation_link) do
          [waitlist_submissions_to_be_accepted,
           waitlist_submission_over_the_limit]
        end
        let!(:waitlist_submissions_to_be_accepted) do
          FactoryGirl.create_list(:submission, 2,
                                  :with_rates,
                                  confirmation_status: nil,
                                  rates_num: setting.required_rates_num,
                                  rates_val: 2)
        end
        let!(:waitlist_submission_over_the_limit) do
          FactoryGirl.create(:submission,
                             :with_rates,
                             confirmation_status: nil,
                             rates_num: setting.required_rates_num,
                             rates_val: 1)
        end
        let!(:waitlist_submission_that_already_has_confirmation_link) do
           FactoryGirl.create(:submission,
                              :with_rates,
                              confirmation_status: 'awaiting',
                              rates_num: setting.required_rates_num,
                              rates_val: 3)
        end
        let(:message_delivery) { instance_double ActionMailer::MessageDelivery }

        before do
          expect(submission_repository).to receive(:waitlist).and_return(waitlist_submissions)
          expect(waitlist_submissions).to receive(:select).and_return(waitlist_submissions_without_confirmation_link)
        end

        it 'sends emails to correct waitlist submissions' do
          expect(ResultsMailer).to receive(:accepted_email)
            .once.with(waitlist_submissions_to_be_accepted[0]).and_return(message_delivery)
          expect(ResultsMailer).to receive(:accepted_email)
            .once.with(waitlist_submissions_to_be_accepted[1]).and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_now).twice

          expect(ResultsMailer).not_to receive(:accepted_email)
            .with(waitlist_submission_over_the_limit)
          expect(ResultsMailer).not_to receive(:accepted_email) .with(waitlist_submission_that_already_has_confirmation_link)

          subject.call
        end

        it 'generates token for correct waitlist submissions' do
          subject.call
          expect(waitlist_submissions_to_be_accepted[0].confirmation_token).to be_present
          expect(waitlist_submissions_to_be_accepted[1].confirmation_token).to be_present
          expect(waitlist_submission_over_the_limit.confirmation_token).to be_nil
          expect(waitlist_submission_that_already_has_confirmation_link.confirmation_token).to be_nil
        end

        it 'changes confirmation status for correct waitlist submissions' do
          subject.call
          expect(waitlist_submissions_to_be_accepted).to all(be_awaiting)
          expect(waitlist_submission_over_the_limit.confirmation_status).to be_nil
          expect(waitlist_submission_that_already_has_confirmation_link).to be_awaiting
        end
      end

      context 'when there are no waitlist submissions' do
        it 'sends no emails' do
          expect(ResultsMailer).not_to receive(:accepted_email)
          subject.call
        end
      end
    end

    context "when there are no expired submissions" do
      it 'sends no emails' do
        expect(ResultsMailer).not_to receive(:accepted_email)
        subject.call
      end
    end
  end
end
