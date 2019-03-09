class Setting < ActiveRecord::Base
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
            presence: true
  validates :available_spots, :required_rates_num, :days_to_confirm_invitation,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.get
    self.first || self.create({
      available_spots: 0,
      required_rates_num: 3,
      days_to_confirm_invitation: 7,
      beginning_of_preparation_period: "Tue, 21 Jun 2016 00:00:00 CEST +02:00",
      beginning_of_registration_period: "Wed, 22 Jun 2016 00:00:00 CEST +02:00",
      beginning_of_closed_period: "Thu, 23 Jun 2016 00:00:00 CEST +02:00",
      event_start_date: "Sat, 16 Apr 2016",
      event_end_date: "Sun, 17 Apr 2016",
      event_url: "railsgirls.com/krakow",
      event_venue: ""
    })
  end

  def self.set(setting_params)
    settings = self.get
    settings.available_spots = setting_params[:available_spots]
    settings.required_rates_num = setting_params[:required_rates_num]
    settings.days_to_confirm_invitation = setting_params[:days_to_confirm_invitation]
    settings.beginning_of_preparation_period = setting_params[:beginning_of_preparation_period]
    settings.beginning_of_registration_period = setting_params[:beginning_of_registration_period]
    settings.beginning_of_closed_period = setting_params[:beginning_of_closed_period]
    settings.event_start_date = setting_params[:event_start_date]
    settings.event_end_date = setting_params[:event_end_date]
    settings.event_url = setting_params[:event_url]
    settings.event_venue = setting_params[:event_venue]

    settings.save!
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
