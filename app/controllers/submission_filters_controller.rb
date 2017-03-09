class SubmissionFiltersController < ApplicationController
  layout 'admin'

  def valid
    submissions_valid = SubmissionRepository.new.valid

    render :list, locals: {
      submission_presenters: SubmissionPresenter.collection(submissions_valid, current_user),
      show_average: true,
      show_rates_count: true,
      filter: :valid
    }
  end

  def rejected
    submissions_rejected = SubmissionRepository.new.rejected

    render :list, locals: {
      submission_presenters: SubmissionPresenter.collection(submissions_rejected, current_user),
      show_average: false,
      show_rates_count: false,
      filter: :rejected
    }
  end

  def to_rate
    submissions_to_rate = SubmissionRepository.new.to_rate

    render :list, locals: {
      submission_presenters: SubmissionPresenter.collection(submissions_to_rate, current_user),
      show_average: false,
      show_rates_count: true,
      filter: :to_rate
    }
  end

  def results
    results = SubmissionRepository.new.rated

    render :results, locals: {
      submissions_results: SubmissionPresenter.collection(results, current_user),
    }
  end

  def participants
    participants = SubmissionRepository.new.participants
    submissions = SubmissionPresenter.collection(participants, current_user)

    render :participants, locals: {
      submissions_participants: submissions
    }
  end
end
