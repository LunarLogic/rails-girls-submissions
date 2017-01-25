require 'rails_helper'

RSpec.describe RateCreator do
  let(:submission) { FactoryGirl.create(:submission) }
  let(:user) { FactoryGirl.create(:user) }
  let(:value) { 1 }
  subject { described_class.build(value, submission.id, user.id) }

  context 'when no rates' do
    it 'creates a new rate' do
      result = subject.call
      expect(Rate.where(value: value, submission_id: submission.id, user_id: user.id).first).not_to be_nil
      expect(result.success).to be true
    end
  end

  context 'with existing rate' do
    let!(:rate) { FactoryGirl.create(:rate, submission: submission, user: user, value: 3) }

    it 'updates the rate' do
      result = subject.call
      expect { result }.not_to change(Rate, :count)
      rate.reload
      expect(rate.value).to eq(value)
    end
  end
end
