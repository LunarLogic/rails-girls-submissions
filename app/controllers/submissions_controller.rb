class SubmissionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :thank_you]
  layout 'dashboard', only: [:all, :rated, :to_rate, :rejected, :results]

  def all
    submissions = Submission.all

    render :list, locals: { submission_presenters: create_submission_presenters(submissions),
      show_average: true, show_rates_count: true }
  end

  def rated
    submissions_rated = SubmissionRepository.new.rated

    render :list, locals: { submission_presenters: create_submission_presenters(submissions_rated),
      show_average: true, show_rates_count: true }
  end

  def to_rate
    submissions_to_rate = SubmissionRepository.new.to_rate

    render :list, locals: { submission_presenters: create_submission_presenters(submissions_to_rate),
      show_average: false, show_rates_count: true }
  end

  def rejected
    submissions_rejected = SubmissionRepository.new.rejected

    render :list, locals: { submission_presenters: create_submission_presenters(submissions_rejected),
      show_average: false, show_rates_count: false  }
  end

  def results
    submissions_accepted = SubmissionRepository.new.accepted
    submissions_waitlist = SubmissionRepository.new.waitlist
    submissions_unaccepted = SubmissionRepository.new.unaccepted

    render :results, locals: { submissions_accepted: submissions_accepted, submissions_waitlist: submissions_waitlist,
    submissions_unaccepted: submissions_unaccepted }
  end

  def show
    submission = Submission.find(params[:id])
    comment = Comment.new

    rate_presenters = create_rate_presenters(submission.rates)
    comment_presenters = create_comment_presenters(submission.comments)

    render :show, locals: { comment: comment, submission: submission,
      comment_presenters: comment_presenters, rate_presenters: rate_presenters }
  end

  def new
    if Setting.preparation_period?
      render :preparation
    elsif Setting.registration_period?
      submission = Submission.new
      render :new, locals: { submission: submission }
    else
      render :closed
    end
  end

  def thank_you
  end

  def create
    submission = Submission.new(submission_params)

    if submission.valid?
      submission_rejector = SubmissionRejector.new.reject_if_any_rules_broken(submission)
      submission.save

      redirect_to submissions_thank_you_url
    else
      render :new, locals: { submission: submission }
    end
  end

  def destroy
    submission = Submission.find(params[:id])
    submission.destroy

    redirect_to submissions_url, notice: 'Submission was successfully destroyed.'
  end

  private
    def submission_params
      params.require(:submission).permit(:full_name, :email, :age,
      :codecademy_username, :description, :html, :css, :js, :ror, :db,
      :programming_others, :english, :operating_system, :first_time, :goals,
      :problems)
    end

    def create_rate_presenters(rates)
      rates.map { |rate| RatePresenter.new(rate, rate.user) }
    end

    def create_comment_presenters(comments)
      comments.map { |comment| CommentPresenter.new(comment, comment.user) }
    end

    def create_submission_presenters(submissions)
      submissions.map { |submission| SubmissionPresenter.new(submission, submission.rates) }
    end
end
