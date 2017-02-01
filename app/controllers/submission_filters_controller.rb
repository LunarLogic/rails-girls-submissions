class SubmissionFiltersController < ApplicationController
  layout 'dashboard'

  def valid
    submissions_valid = SubmissionRepository.new.valid

    render :list, locals: {
      submission_presenters: create_submission_presenters(submissions_valid),
      show_average: true,
      show_rates_count: true
    }
  end

  def rejected
    submissions_rejected = SubmissionRepository.new.rejected

    render :list, locals: {
      submission_presenters: create_submission_presenters(submissions_rejected),
      show_average: false,
      show_rates_count: false
    }
  end

  def to_rate
    submissions_to_rate = SubmissionRepository.new.to_rate

    render :list, locals: {
      submission_presenters: create_submission_presenters(submissions_to_rate),
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

  def create_submission_presenters(submissions)
    submissions.map do |submission|
      SubmissionPresenter.new(
        submission,
        submission.rates,
        SubmissionRepository.new,
        current_user
      )
    end
  end
end
