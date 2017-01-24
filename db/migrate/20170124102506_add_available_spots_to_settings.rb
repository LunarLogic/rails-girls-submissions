class AddAvailableSpotsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :available_spots, :integer
  end
end
