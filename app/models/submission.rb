class Submission < ApplicationRecord
  validates :full_name, :email, :description, :english,
            :operating_system, :goals, :gender, presence: true
  validates :first_time, inclusion: { in: [true, false] }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :email, uniqueness: { case_sensitive: false }
  validates :description, :goals, length: { maximum: 500 }
  validates :problems, :full_name, :email, :gender, length: { maximum: 255 }

  has_many :rates, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  def status
    if rejected
      :rejected
    elsif rated?
      :rated
    else
      :to_rate
    end
  end

  def rated?
    rates.length >= Setting.get.required_rates_num
  end

  def average_rate
    rates.count == 0 ? 0 : (rates.sum(:value).to_f / rates.count)
  end

  def generate_invitation_token!
    self.invitation_token = Devise.friendly_token
    self.invitation_token_created_at = Time.zone.now
    save!
  end

  def mark_bad_news_delivery!
    self.bad_news_sent_at = Time.zone.now
    save!
  end

  def confirm_invitation!
    self.invitation_confirmed = true
    save!
  end

  def invitation_expired?
    raise 'Submission not invited!' unless invitation_token

    after_deadline = invitation_token_created_at < Setting.get.days_to_confirm_invitation.days.ago
    after_deadline && !invitation_confirmed?
  end

  def invitation_status
    if !invitation_token
      :not_invited
    elsif invitation_confirmed
      :confirmed
    elsif old_token?
      :expired
    else
      :invited
    end
  end

  private

  def old_token?
    invitation_token_created_at < Setting.get.days_to_confirm_invitation.days.ago
  end
end
