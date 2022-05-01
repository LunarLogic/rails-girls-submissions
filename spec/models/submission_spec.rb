require "rails_helper"

RSpec.describe Submission, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:submission)).to be_valid
  end

  it "requires a full_name" do
    expect(FactoryBot.build(:submission, full_name: "")).not_to be_valid
  end

  it "requires a valid email" do
    expect(FactoryBot.build(:submission, email: "invalid#email.io")).not_to be_valid
    expect(FactoryBot.build(:submission, email: "invalid@emaiio")).not_to be_valid
  end

  describe '#generate_invitation_token!' do
    let(:submission) { FactoryBot.create(:submission) }

    it 'generates invitation token' do
      submission.generate_invitation_token!
      expect(submission.invitation_token).not_to be_nil
      expect(submission.invitation_token_created_at).not_to be_nil
    end
  end

  describe '#invitation_expired?' do
    before { allow(Setting).to receive(:get).and_return(FactoryBot.build(:setting)) }
    let(:confirmation_days) { Setting.get.days_to_confirm_invitation.days }

    let(:expired_submission) do
      FactoryBot.build(
        :submission,
        invitation_token: 'xxx',
        invitation_token_created_at: confirmation_days.ago - 1,
        invitation_confirmed: false
      )
    end
    let(:confirmed_submission) do
      FactoryBot.build(
        :submission,
        invitation_token: 'xxx',
        invitation_token_created_at: confirmation_days.ago - 1,
        invitation_confirmed: true
      )
    end
    let(:not_invited_submission) do
      FactoryBot.build(
        :submission,
        invitation_token: nil,
        invitation_token_created_at: nil,
        invitation_confirmed: false
      )
    end

    it 'returns true when token expired and invitation is not confirmed' do
      expect(expired_submission.invitation_expired?).to be true
    end

    it 'returns false for confirmed submission' do
      expect(confirmed_submission.invitation_expired?).to be false
    end

    it 'raise an error for not ivited submission' do
      expect{ not_invited_submission.invitation_expired? }.to raise_error('Submission not invited!')
    end
  end

  describe "#invitation_status" do
    let(:submission) { FactoryBot.build(:submission) }

    subject { submission.invitation_status }

    context ":not_invited" do
      before { allow(submission).to receive(:invitation_token).and_return(nil) }
      it { is_expected.to eq(:not_invited) }
    end

    context ":confirmed" do
      before do
        allow(submission).to receive(:invitation_token).and_return('aa')
        allow(submission).to receive(:invitation_confirmed).and_return(true)
      end
      it { is_expected.to eq(:confirmed) }
    end

    context ":expired" do
      before do
        allow(submission).to receive(:invitation_token).and_return('aa')
        allow(submission).to receive(:invitation_confirmed).and_return(false)
        allow(submission).to receive(:invitation_token_created_at).and_return(100.years.ago)
      end
      it { is_expected.to eq(:expired) }
    end

    context ":invited" do
      let(:setting) { double(days_to_confirm_invitation: 5) }

      before do
        allow(Setting).to receive(:get).and_return(setting)

        allow(submission).to receive(:invitation_token).and_return('aa')
        allow(submission).to receive(:invitation_confirmed).and_return(false)
        allow(submission).to receive(:invitation_token_created_at).and_return(1.hour.ago)
      end
      it { is_expected.to eq(:invited) }
    end
  end
end
