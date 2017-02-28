class SubmissionFiltersController < ApplicationController
  layout 'dashboard'

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
    submissions_accepted = SubmissionRepository.new.accepted
    submissions_waitlist = SubmissionRepository.new.waitlist

    render :results, locals: {
      submissions_accepted: SubmissionPresenter.collection(submissions_accepted, current_user),
      submissions_waitlist: SubmissionPresenter.collection(submissions_waitlist, current_user)
    }
  end

  def invitations
    with_confirmed_invitation = SubmissionRepository.new.with_confirmed_invitation
    submissions = SubmissionPresenter.collection(with_confirmed_invitation, current_user)

    render :invitations, locals: {
      submissions_with_confirmed_invitation: submissions
    }
  end
end
