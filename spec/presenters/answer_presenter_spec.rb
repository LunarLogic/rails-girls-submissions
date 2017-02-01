require 'rails_helper'

RSpec.describe AnswerPresenter do
  let(:answer) { instance_double("Answer", value: "a_little_bit") }
  let(:question) { instance_double("Question", text: "text") }

  describe "#question_text" do
    subject { described_class.new(answer, question).question_text }

    it { is_expected.to eq(question.text) }
  end

  describe "#value" do
    subject { described_class.new(answer, question).value }

    it "removes underscores from answer's enum value" do
      is_expected.to eq("a little bit")
    end
  end
end
