class QuestionsController < ApplicationController
  def index
    render :index
  end

  def new
    question = Question.new
    render :new, locals: { question: question }
  end

  def create
    text = question_params[:text]
    question = Question.create(text: text)

    redirect_to :questions
  end

  private

  def question_params
    params.require(:question).permit(:text)
  end
end
