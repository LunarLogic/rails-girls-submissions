class SubmissionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :thank_you]

  def show
    submission = Submission.find(params[:id])

    render :show, locals: {
      submission: SubmissionPresenter.build(submission, current_user),
      comment: Comment.new,
      comment_presenters: CommentPresenter.collection(submission.comments),
      rate_presenters: RatePresenter.collection(submission.rates)
    }
  end

  def new
    if Setting.preparation_period?
      render :preparation
    elsif Setting.registration_period?
      render :new, locals: {
        submission: Submission.new,
        answers: build_form_answers(form_questions),
        footer_presenter: FooterPresenter.new(Setting.get)
      }
    else
      render :closed
    end
  end

  def thank_you
    render :thank_you
  end

  def create
    submission = Submission.new(submission_params)

    if submission.valid?
      SubmissionRejector.new.reject_if_any_rules_broken(submission)
      submission.save
      attributes_collection = answers_attributes(answers_params, submission.id)
      Answer.create_collection(attributes_collection)

      redirect_to submissions_thank_you_url
    else
      render :new, locals: {
        submission: submission,
        answers: build_form_answers(form_questions),
        footer_presenter: FooterPresenter.new(Setting.get)
      }
    end
  end

  private

  def submission_params
    params.require(:submission).permit(:full_name, :email, :age, :codecademy_username,
      :description, :html, :css, :js, :ror, :db, :programming_others, :english,
      :operating_system, :first_time, :goals, :problems)
  end

  def answers_params
    params.require(:submission)
      .permit(answers_attributes: [:value, :question_id])[:answers_attributes]
  end

  def answers_attributes(answers_params, submission_id)
    if answers_params
      answers_params.values.map { |params| params.merge({ submission_id: submission_id }) }
    else
      {}
    end
  end

  def build_form_answers(questions)
    questions.map { |q| Answer.new(question: q) }
  end

  def form_questions
    Question.all
  end
end
