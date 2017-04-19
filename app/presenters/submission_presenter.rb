class SubmissionPresenter < SimpleDelegator
  def self.collection(submissions, user)
    submissions.map { |s| new(s, s.rates, SubmissionRepository.new, user) }
  end

  def self.build(submission, user)
    new(submission, submission.rates, SubmissionRepository.new, user)
  end

  def initialize(submission, rates, submission_repository, user)
    super(submission)
    @rates = rates
    @submission_repository = submission_repository
    @user = user
  end

  def average_rate
    if submission.rated?
      rates.average(:value).to_f.round(2)
    else
      nil
    end
  end

  def rates_count
    rates.count
  end

  def created_at
    submission.created_at.strftime("%m-%d-%Y")
  end

  def next
    submission_repository.next(submission.created_at)
  end

  def previous
    submission_repository.previous(submission.created_at)
  end

  def current_user_rate_value
    rate = Rate.find_by(submission_id: submission.id, user_id: user.id)
    rate ? rate.value : 0
  end

  def codecademy_url
    "https://www.codecademy.com/#{codecademy_username}"
  end

  def status
    symbol_to_string(submission.status)
  end

  def invitation_status
    symbol_to_string(submission.invitation_status)
  end

  private

  attr_reader :rates, :submission_repository, :user

  def submission
    __getobj__
  end

  def symbol_to_string(symbol)
    symbol.to_s.gsub('_', ' ')
  end
end
