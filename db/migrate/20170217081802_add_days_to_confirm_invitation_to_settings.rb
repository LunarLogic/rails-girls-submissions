class AddDaysToConfirmInvitationToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :days_to_confirm_invitation, :integer, null: false
  end
end
