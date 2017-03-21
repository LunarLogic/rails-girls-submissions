class AddInvitationProcessStartedToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :invitation_process_started, :boolean, default: false, null: false
  end
end
