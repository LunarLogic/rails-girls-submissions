class AddFooterFieldsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :event_start_date, :date, null: false
    add_column :settings, :event_end_date, :date, null: false
    add_column :settings, :event_url, :string, null: false
  end
end
