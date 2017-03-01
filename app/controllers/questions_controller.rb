class QuestionsController < ApplicationController
  layout 'admin'
  
  def index
    render :index, locals: { questions: Question.all, question: Question.new }
  end

  def create
    Question.create(question_params)
    redirect_to :questions
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy
    redirect_to :questions
  end

  private

  def question_params
    params.require(:question).permit(:text)
  end
end
