require 'rails_helper'

RSpec.describe InvitationsMailer, type: :mailer do
  let(:submission) { double email: "example@email.com", invitation_token: 'xxx' }
  let(:url) { "#{submissions_confirm_url(host: 'localhost', port: '3000')}" }

  shared_examples 'email with confirmation link' do
    it 'sends to correct email addres' do
      expect(mail.to).to eq([submission.email])
    end

    it 'sends correct confirmation url' do
      expect(mail.body.encoded).to include("#{url}?invitation_token=#{submission.invitation_token}")
    end
  end

  describe '#invitation_email' do
    let(:mail) { described_class.invitation_email(submission).deliver_now }

    it_behaves_like 'email with confirmation link'
  end

  describe '#reminder_email' do
    let(:mail) { described_class.reminder_email(submission).deliver_now }

    it_behaves_like 'email with confirmation link'
  end
end
