class SubmissionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :thank_you]

  def show
    submission = Submission.find(params[:id])
    submission_presenter = SubmissionPresenter.new(
      submission,
      submission.rates,
      SubmissionRepository.new,
      current_user
    )

    rate_presenters = create_rate_presenters(submission.rates)
    comment_presenters = create_comment_presenters(submission.comments)

    render :show, locals: {
      comment: Comment.new,
      comment_presenters: comment_presenters,
      rate_presenters: rate_presenters,
      submission: submission_presenter
    }
  end

  def new
    if Setting.preparation_period?
      render :preparation
    elsif Setting.registration_period?
      submission = Submission.new
      footer_presenter = FooterPresenter.new(Setting.get)
      answers = form_answers(form_questions)

      render :new, locals: {
        submission: submission,
        answers: answers,
        footer_presenter: footer_presenter
      }
    else
      render :closed
    end
  end

  def thank_you
  end

  def create
    submission = Submission.new(submission_params)

    if submission.valid?
      SubmissionRejector.new.reject_if_any_rules_broken(submission)
      submission.save

      create_answers(answers_params, submission.id)

      redirect_to submissions_thank_you_url
    else
      footer_presenter = FooterPresenter.new(Setting.get)
      answers = form_answers(form_questions)

      render :new, locals: {
        submission: submission,
        answers: answers,
        footer_presenter: footer_presenter
      }
    end
  end

  def destroy
    submission = Submission.find(params[:id])
    submission.destroy

    redirect_to submissions_url, notice: 'Submission was successfully destroyed.'
  end

  private

  def submission_params
    params.require(:submission).permit(:full_name, :email, :age, :codecademy_username,
      :description, :html, :css, :js, :ror, :db, :programming_others, :english,
      :operating_system, :first_time, :goals, :problems)
  end

  def answers_params
    attributes = params.require(:submission)
      .permit(answers_attributes: [:value, :question_id])[:answers_attributes]

    attributes ? attributes.values : {}
  end

  def create_rate_presenters(rates)
    rates.map { |rate| RatePresenter.new(rate, rate.user) }
  end

  def create_comment_presenters(comments)
    comments.map { |comment| CommentPresenter.new(comment, comment.user) }
  end

  def form_answers(questions)
    questions.map { |q| Answer.new(question: q) }
  end

  def form_questions
    Question.all
  end

  def create_answers(answers_params, submission_id)
    answers_params.map do |a|
      Answer.create(a.merge({ submission_id: submission_id }))
    end
  end
end
