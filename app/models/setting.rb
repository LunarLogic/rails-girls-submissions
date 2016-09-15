class Setting < ActiveRecord::Base
  validate :preparation_is_before_registration, :registration_is_before_closed

  def self.get
    self.first || self.create({
      accepted_threshold: 0,
      waitlist_threshold: 0,
      required_rates_num: 3,
      beginning_of_preparation_period: "Thu, 21 Jun 2016 00:00:00 CEST +02:00",
      beginning_of_registration_period: "Thu, 22 Jun 2016 00:00:00 CEST +02:00",
      beginning_of_closed_period: "Thu, 23 Jun 2016 00:00:00 CEST +02:00",
      event_start_date: "Sat, 16 Apr 2016",
      event_end_date: "Sun, 17 Apr 2016",
      event_url: "railsgirls.com/krakow"
    })
  end

  def self.set(setting_params)
    settings = self.get
    settings.accepted_threshold = setting_params[:accepted_threshold]
    settings.waitlist_threshold = setting_params[:waitlist_threshold]
    settings.required_rates_num = setting_params[:required_rates_num]
    settings.beginning_of_preparation_period = setting_params[:beginning_of_preparation_period]
    settings.beginning_of_registration_period = setting_params[:beginning_of_registration_period]
    settings.beginning_of_closed_period = setting_params[:beginning_of_closed_period]
    settings.event_start_date = setting_params[:event_start_date]
    settings.event_end_date = setting_params[:event_end_date]
    settings.event_url = setting_params[:event_url]

    settings.save!
  end

  def self.preparation_period?
    settings = self.get
    settings.beginning_of_preparation_period <= Time.now && Time.now < settings.beginning_of_registration_period
  end

  def self.registration_period?
    settings = self.get
    settings.beginning_of_registration_period <= Time.now && Time.now < settings.beginning_of_closed_period
  end

  private

  def preparation_is_before_registration
    if beginning_of_registration_period < beginning_of_preparation_period
      errors.add(:beginning_of_preparation_period, "has to be before beginning_of_registration_period")
    end
  end

  def registration_is_before_closed
    if beginning_of_closed_period < beginning_of_registration_period
      errors.add(:beginning_of_registration_period, "has to be before beginning_of_closed_period")
    end
  end
end
