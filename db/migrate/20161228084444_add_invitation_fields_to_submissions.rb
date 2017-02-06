class AddInvitationFieldsToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :invitation_token, :string
    add_column :submissions, :invitation_token_created_at, :datetime
  end
end
