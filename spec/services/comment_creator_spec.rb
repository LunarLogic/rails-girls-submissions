require 'rails_helper'

RSpec.describe CommentCreator do
  let!(:submission) { FactoryBot.create(:submission) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:comment_body) { "comment" }
  subject { described_class.build(comment_body, submission.id, user.id) }

  it "creates a new comment" do
    result = subject.call
    expect(Comment.where(body: "comment", submission_id: submission.id, user_id: user.id).first).not_to be_nil
    expect(result.success).to be true
  end
end
