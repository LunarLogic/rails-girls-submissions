require 'rails_helper'

RSpec.describe Authorizator do
  describe '#allowed_to_log_in?' do
    let!(:test_email) { "test@example.com" }

    subject { described_class.new.allowed_to_log_in?(user) }

    context "when test_email is in the allowed_users.yml file" do
      let!(:user) { FactoryGirl.create(:user, email: test_email ) }
      it { expect(subject).to equal(true) }
    end

    context "when the user's email is not in the allowed_users.yml file" do
      let!(:user) { FactoryGirl.create(:user) }
      it { expect(subject).to equal(false) }
    end
  end
end
