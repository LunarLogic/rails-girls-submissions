class SettingPresenter
  def initialize(setting)
    @setting = setting
  end

  def first_day
    formatted_date(setting.event_start_date)
  end

  def second_day
    formatted_date(setting.event_end_date)
  end

  def event_dates
    if setting.event_start_date.month == setting.event_end_date.month
      "#{setting.event_start_date.day}-#{formatted_date(setting.event_end_date)}"
    else
      "#{formatted_date(setting.event_start_date)}-#{formatted_date(setting.event_end_date)}"
    end
  end

  def event_dates_with_year
    "#{event_dates} #{setting.event_end_date.year}"
  end

  def registration_ends
    formatted_date(setting.end_of_registration_period)
  end

  delegate :event_url, to: :setting

  delegate :event_venue, to: :setting

  private

  def formatted_date(date)
    date.strftime("%-d %B")
  end

  attr_reader :setting
end
