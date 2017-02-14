class Submission < ActiveRecord::Base
  validates :full_name, :age, :email, :codecademy_username, :description, :html, :css, :js, :ror, :db,
            :programming_others, :english, :operating_system, :goals, presence: true
  validates :first_time, inclusion: { in: [true, false] }
  validates :age, numericality: { greater_than_or_equal_to: 0, less_than: 110 }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :email, uniqueness: { case_sensitive: false }
  validates :full_name, :email, :codecademy_username, length: { maximum: 50 }
  validates :description, :goals, :problems, length: { maximum: 255 }

  has_many :rates, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  SKILLS = ['html', 'css', 'js', 'ror', 'db', 'programming_others']

  def status
    if rejected
      "rejected"
    else
      rates.length >= Setting.get.required_rates_num ? "rated" : "pending"
    end
  end

  def rated?
    status == "rated"
  end

  def average_rate
    rates.count == 0 ? 0 : (rates.sum(:value).to_f / rates.count)
  end

  def generate_invitation_token!
    self.invitation_token = Devise.friendly_token
    self.invitation_token_created_at = Time.current
    save!
  end

  def confirm_invitation!
    self.invitation_confirmed = true
    save!
  end

  def invitation_expired?
    if invitation_token
      invitation_token_created_at < 1.week.ago && !invitation_confirmed?
    else
      raise 'Submission not invited!'
    end
  end
end
