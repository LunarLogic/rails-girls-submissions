require 'rails_helper'

RSpec.describe CommentCreator do
  subject(:comment_creator) { described_class.build(comment_body, submission.id, user.id) }

  let!(:submission) { FactoryBot.create(:submission) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:comment_body) { "comment" }

  it "creates a new comment" do
    result = comment_creator.call
    expect(Comment.where(body: "comment", submission_id: submission.id, user_id: user.id).first).not_to be_nil
    expect(result.success).to be true
  end
end
