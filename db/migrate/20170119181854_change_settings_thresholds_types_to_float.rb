class ChangeSettingsThresholdsTypesToFloat < ActiveRecord::Migration
  def change
    change_table :settings do | t |
      t.change :accepted_threshold, :float
      t.change :waitlist_threshold, :float
    end
  end
end
