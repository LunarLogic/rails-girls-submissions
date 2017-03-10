class SubmissionFiltersController < ApplicationController
  layout 'admin'

  def valid
    submissions_valid = SubmissionRepository.new.valid

    render :valid, locals: {
      submission_presenters: SubmissionPresenter.collection(submissions_valid, current_user),
      filter: :valid
    }
  end

  def rejected
    submissions_rejected = SubmissionRepository.new.rejected

    render :rejected, locals: {
      submission_presenters: SubmissionPresenter.collection(submissions_rejected, current_user),
      filter: :rejected
    }
  end

  def to_rate
    submissions_to_rate = SubmissionRepository.new.to_rate

    render :to_rate, locals: {
      submission_presenters: SubmissionPresenter.collection(submissions_to_rate, current_user),
      filter: :to_rate
    }
  end

  def results
    results = SubmissionRepository.new.rated

    render :results, locals: {
      submission_presenters: SubmissionPresenter.collection(results, current_user),
      filter: :results
    }
  end

  def participants
    participants = SubmissionRepository.new.participants

    render :participants, locals: {
      submission_presenters: SubmissionPresenter.collection(participants, current_user),
      filter: :participants
    }
  end
end
