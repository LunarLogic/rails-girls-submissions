class Setting < ActiveRecord::Base
  attr_accessor :end_of_registration_period

  validate :preparation_is_before_registration,
           :registration_is_before_closed,
           :start_is_before_end
  validates :required_rates_num,
            :beginning_of_preparation_period,
            :beginning_of_registration_period,
            :beginning_of_closed_period,
            :event_start_date,
            :event_end_date,
            :event_url,
            :available_spots,
            :required_rates_num,
            :days_to_confirm_invitation,
            :contact_email,
            presence: true
  validates :available_spots, :required_rates_num, :days_to_confirm_invitation,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def end_of_registration_period
    (beginning_of_closed_period - 1.day).end_of_day
  end

  def end_of_registration_period=(value)
    value = value.is_a?(Time) ? value : Time.zone.parse(value)
    self.beginning_of_closed_period = (value + 1.day).beginning_of_day
  end

  def self.get
    self.first || self.create({
      available_spots: 0,
      required_rates_num: 3,
      days_to_confirm_invitation: 7,
      beginning_of_preparation_period: "Fri, 1 Apr 2022 00:00:00 CEST +02:00",
      beginning_of_registration_period: "Thu, 7 Apr 2022 00:00:00 CEST +02:00",
      beginning_of_closed_period: "Sat, 30 Apr 2022 00:00:00 CEST +02:00",
      event_start_date: "Fri, 10 Jun 2022",
      event_end_date: "Sat, 11 Jun 2022",
      event_url: "railsgirls.com/krakow",
      event_venue: "",
      contact_email: "example@example.com",
    })
  end

  def self.preparation_period?
    settings = self.get
    preparation_period = settings.beginning_of_preparation_period...settings.beginning_of_registration_period

    preparation_period.cover?(Time.zone.now)
  end

  def self.registration_period?
    settings = self.get
    registration_period = settings.beginning_of_registration_period...settings.beginning_of_closed_period

    registration_period.cover?(Time.zone.now)
  end

  private

  def preparation_is_before_registration
    return unless beginning_of_registration_period && beginning_of_preparation_period
    if beginning_of_registration_period < beginning_of_preparation_period
      errors.add(:beginning_of_preparation_period, "has to be before beginning_of_registration_period")
    end
  end

  def registration_is_before_closed
    return unless beginning_of_closed_period && beginning_of_registration_period
    if beginning_of_closed_period < beginning_of_registration_period
      errors.add(:beginning_of_registration_period, "has to be before beginning_of_closed_period")
    end
  end

  def start_is_before_end
    return unless event_end_date && event_start_date
    if event_end_date < event_start_date
      errors.add(:event_start_date, "has to be before event_end_date")
    end
  end
end
