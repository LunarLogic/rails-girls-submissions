class ChangeAcceptedWaitlistThresholdFromIntToFloat < ActiveRecord::Migration
  def up
    change_column :settings, :accepted_threshold, :float
    change_column :settings, :waitlist_threshold, :float
  end

  def down
    change_column :settings, :accepted_threshold, :integer
    change_column :settings, :waitlist_threshold, :integer
  end
end
