class AddEventVenueToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :event_venue, :string
  end
end
