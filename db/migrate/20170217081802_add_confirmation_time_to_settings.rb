class AddConfirmationTimeToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :confirmation_time, :integer, null: false
  end
end
