require 'rails_helper'

RSpec.describe RateCreator do
  subject(:call) { described_class.build(value, submission.id, user.id).call }

  let(:submission) { FactoryBot.create(:submission) }
  let(:user) { FactoryBot.create(:user) }
  let(:value) { 1 }

  context 'when the user hasnt rated the submission yet' do
    it 'creates a new rate' do
      expect { call }.to change(Rate, :count).from(0).to(1)
      expect(Rate.find_by(value: value, submission_id: submission.id, user_id: user.id)).not_to be_nil
    end
  end

  context 'when the user already rated the submission' do
    let!(:rate) { FactoryBot.create(:rate, submission: submission, user: user, value: 3) }

    it 'updates the rate' do
      expect { call }.not_to change(Rate, :count)
      rate.reload
      expect(rate.value).to eq(value)
    end
  end
end
