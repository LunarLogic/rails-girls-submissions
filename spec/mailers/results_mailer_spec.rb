require 'rails_helper'

RSpec.describe ResultsMailer, type: :mailer do
  describe '#accepted_email' do
    let(:submission) { double email: "example@email.com", confirmation_token: 'xxx' }
    let(:mail) { described_class.accepted_email(submission).deliver_now }
    let(:url) { "#{submissions_confirm_url(host: 'localhost', port: '3000')}" }

    it 'sends to correct email addres' do
      expect(mail.to).to eq([submission.email])
    end

    it 'sends correct confirmation url' do
      expect(mail.body.encoded)
        .to include("#{url}?confirmation_token=#{submission.confirmation_token}")
    end
  end
end
