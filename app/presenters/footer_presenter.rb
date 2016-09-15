class FooterPresenter
  def initialize(setting)
    @setting = setting
  end

  def event_dates
    "#{@setting.event_start_date.day}-#{@setting.event_end_date.strftime("%d %B")}"
  end

  def event_url
    @setting.event_url
  end
end
