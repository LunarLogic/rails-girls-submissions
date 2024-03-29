require 'rails_helper'

RSpec.describe InvitationsMailer, type: :mailer do
  let(:submission) { instance_double(Submission, email: "example@email.com", invitation_token: 'xxx') }
  let(:url) { submissions_confirm_invitation_url.to_s }
  let(:event_dates) { double }
  let(:event_venue) { double }
  let(:contact_email) { 'test@example.com' }

  shared_examples 'email with confirmation link' do
    it 'sends to correct email addres' do
      expect(mail.to).to eq([submission.email])
    end

    it 'sends correct confirmation url' do
      expect(mail.html_part.body).to include("#{url}?invitation_token=#{submission.invitation_token}")
    end

    it 'includes correct reply-to address' do
      expect(mail.reply_to).to eq([contact_email])
    end
  end

  describe '#invitation_email' do
    let(:mail) { described_class.invitation_email(submission, event_dates, event_venue, contact_email).deliver_now }

    it_behaves_like 'email with confirmation link'
  end

  describe '#reminder_email' do
    let(:mail) { described_class.reminder_email(submission, event_dates, event_venue, contact_email).deliver_now }

    it_behaves_like 'email with confirmation link'
  end
end
