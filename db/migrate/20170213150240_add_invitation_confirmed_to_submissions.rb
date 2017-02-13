class AddInvitationConfirmedToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :invitation_confirmed, :boolean, default: false
  end
end
