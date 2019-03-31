class SettingsController < ApplicationController
  layout 'admin'

  def index
    settings = Setting.get
    render :index, locals: { settings: settings }
  end

  def update
    unless dates_order_ok?(setting_params)
      redirect_to settings_path, notice: "Registration start must be after preparation start and before closed start"
      return
    end

    settings = Setting.get

    if settings.update(setting_params)
      redirect_to settings_path, notice: "Settings updated"
    else
      flash[:notice] = "There was a problem with updating settings"
      render :index, locals: { settings: settings }
    end
  end

  private

  def setting_params
    params.require(:setting).permit(
      :available_spots, :required_rates_num, :days_to_confirm_invitation,
      :beginning_of_preparation_period, :beginning_of_registration_period, :end_of_registration_period,
      :event_start_date, :event_end_date, :event_url, :event_venue, :contact_email
    )
  end

  def dates_order_ok?(params)
    params[:beginning_of_preparation_period] < params[:beginning_of_registration_period] &&
    params[:beginning_of_registration_period] <= params[:end_of_registration_period] &&
    params[:event_start_date] < params[:event_end_date]
  end
end
