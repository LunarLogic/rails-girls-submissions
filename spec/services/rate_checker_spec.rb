require 'rails_helper'

RSpec.describe RateChecker do
describe '#user_has_already_rated?' do
    subject { described_class.new(submission.id, user.id).user_has_already_rated? }

    context 'when the submmission has already been rated by the user' do
      let!(:submission) { FactoryGirl.create(:submission) }
      let!(:user) { FactoryGirl.create(:user) }

      it do
        submission.rates << Rate.new(user_id: user.id)
        expect(subject).to equal(true)
      end
    end

    context 'when the submmission has not been rated by the user yet' do
      let!(:submission) { FactoryGirl.create(:submission) }
      let!(:user) { FactoryGirl.create(:user) }
      let!(:user1) { FactoryGirl.create(:user) }

      it do
        submission.rates << Rate.new(user_id: user1.id)
        expect(subject).to equal(false)
      end
    end
  end
end
