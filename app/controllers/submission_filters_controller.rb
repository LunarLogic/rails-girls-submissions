class SubmissionFiltersController < ApplicationController
  layout 'dashboard'

  def valid
    submissions_valid = SubmissionRepository.new.valid

    render :list, locals: {
      submission_presenters: build_submission_presenters(submissions_valid, current_user),
      show_average: true,
      show_rates_count: true
    }
  end

  def rejected
    submissions_rejected = SubmissionRepository.new.rejected

    render :list, locals: {
      submission_presenters: SubmissionPresenter.collection(submissions_rejected, current_user),
      show_average: false,
      show_rates_count: false
    }
  end

  def to_rate
    submissions_to_rate = SubmissionRepository.new.to_rate

    render :list, locals: {
      submission_presenters: SubmissionPresenter.collection(submissions_to_rate, current_user),
      show_average: false,
      show_rates_count: true
    }
  end

  def results
    submissions_accepted = SubmissionRepository.new.accepted
    submissions_waitlist = SubmissionRepository.new.waitlist

    render :results, locals: {
      submissions_accepted: submissions_accepted,
      submissions_waitlist: submissions_waitlist
    }
  end

  private

  def build_submission_presenters(submissions, user)
    submissions.map { |s| SubmissionPresenter.build(s, user) }
  end
end
