class SettingPresenter
  def initialize(setting)
    @setting = setting
  end

  def event_dates
    if setting.event_start_date.month == setting.event_end_date.month
      "#{setting.event_start_date.day}-#{present_date(setting.event_end_date)}"
    else
      "#{present_date(setting.event_start_date)}-#{present_date(setting.event_end_date)}"
    end
  end

  def registration_ends
    present_date(setting.beginning_of_closed_period)
  end

  def event_url
    setting.event_url
  end

  def event_venue
    setting.event_venue
  end

  private

  def present_date(date)
    date.strftime("%d %B")
  end

  attr_reader :setting
end
