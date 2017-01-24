class RemoveAcceptedThresholdFromSettings < ActiveRecord::Migration
  def change
    remove_column :settings, :accepted_threshold
  end
end
