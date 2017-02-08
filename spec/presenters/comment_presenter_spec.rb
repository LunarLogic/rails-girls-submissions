require 'rails_helper'

RSpec.describe CommentPresenter do
  let(:comment) { double }

  before do
    allow(comment).to receive(:user).and_return(double(nickname: "nickname"))
    allow(comment).to receive(:updated_at).and_return(DateTime.new(2017, 2, 1))
    allow(comment).to receive(:body).and_return("body")
  end

  subject { described_class.new(comment, comment.user) }

  it "presents comment's user nickname" do
    expect(subject.user_nickname).to eq("nickname")
  end

  it "presents comment's timestamp in %d-%m-%Y format" do
    expect(subject.timestamp).to eq("01-02-2017")
  end

  it "presents comment's user nickname" do
    expect(subject.body).to eq("body")
  end
end
