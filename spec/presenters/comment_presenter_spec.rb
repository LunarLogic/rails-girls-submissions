require 'rails_helper'

RSpec.describe CommentPresenter do
  subject(:presenter) { described_class.new(comment, comment.user) }

  let(:comment) { double }

  before do
    allow(comment).to receive(:user).and_return(instance_double(User, nickname: "nickname"))
    allow(comment).to receive(:updated_at).and_return(DateTime.new(2017, 2, 1))
    allow(comment).to receive(:body).and_return("body")
  end

  it "presents comment's user nickname" do
    expect(presenter.user_nickname).to eq("nickname")
  end

  it "presents comment's timestamp in %d-%m-%Y format" do
    expect(presenter.timestamp).to eq("01-02-2017")
  end

  it "presents comment body" do
    expect(presenter.body).to eq("body")
  end
end
