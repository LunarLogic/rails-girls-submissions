require 'rails_helper'

RSpec.describe AnswerPresenter do
  let(:answer) { instance_double("Answer", choice: "a_little_bit") }
  let(:question) { instance_double("Question", text: "text") }

  describe "#question_text" do
    subject { described_class.new(answer, question).question_text }

    it { is_expected.to eq(question.text) }
  end

  describe "#choice" do
    subject(:choice) { described_class.new(answer, question).choice }

    it "removes underscores from answer's enum value" do
      expect(choice).to eq("a little bit")
    end
  end
end
