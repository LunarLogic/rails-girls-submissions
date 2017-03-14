class SettingPresenter
  def initialize(setting)
    @setting = setting
  end

  def event_dates
    if setting.event_start_date.month == setting.event_end_date.month
      "#{setting.event_start_date.day}-#{setting.event_end_date.strftime("%d %B")}"
    else
      "#{setting.event_start_date.strftime("%d %B")}-#{setting.event_end_date.strftime("%d %B")}"
    end
  end

  def event_url
    setting.event_url
  end

  private

  attr_reader :setting
end
