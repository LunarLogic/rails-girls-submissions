require 'rails_helper'

RSpec.describe Authorizator do
  describe '#allowed_to_log_in?' do
    subject { described_class.new.allowed_to_log_in?(user) }

    let!(:test_email) { "test@example.com" }

    context "when test_email is in the allowed_users.yml file" do
      let(:user) { FactoryBot.create(:user, email: test_email ) }

      it { is_expected.to equal(true) }
    end

    context "when the user's email is not in the allowed_users.yml file" do
      let(:user) { FactoryBot.create(:user) }

      it { is_expected.to equal(false) }
    end
  end
end
