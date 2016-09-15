class SettingsController < ApplicationController
  layout 'no-dashboard'

  def index
    settings = Setting.get
    render :index, locals: { settings: settings }
  end

  def update
    if dates_order_ok?(setting_params)
      Setting.set(setting_params)
      redirect_to :back, notice: "Settings are updated"
    else
      redirect_to :back, notice: "Registration start must be after preparation start and before closed start"
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:accepted_threshold, :waitlist_threshold, :required_rates_num,
      :beginning_of_preparation_period, :beginning_of_registration_period, :beginning_of_closed_period)
  end

  def dates_order_ok?(params)
    params[:beginning_of_preparation_period] < params[:beginning_of_registration_period] &&
    params[:beginning_of_registration_period] < params[:beginning_of_closed_period]
  end
end
