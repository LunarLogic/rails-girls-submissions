class RemoveColumnWaitlistThresholdFromSetting < ActiveRecord::Migration
  def change
    remove_column :settings, :waitlist_threshold 
  end
end
