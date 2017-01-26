class AddNullFalseToSomeSettingFields < ActiveRecord::Migration
  def change
    change_column_null :settings, :required_rates_num, false
    change_column_null :settings, :beginning_of_preparation_period, false
    change_column_null :settings, :beginning_of_registration_period, false
    change_column_null :settings, :beginning_of_closed_period, false
    change_column_null :settings, :available_spots, false
  end
end
