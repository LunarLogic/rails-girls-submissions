class AddInvitationFieldsToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :invitation_token, :string
    add_column :submissions, :invitation_token_created_at, :datetime

    add_index :submissions, :invitation_token
  end
end
