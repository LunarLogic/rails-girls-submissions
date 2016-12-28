class AddConfirmationTokenCreatedAtToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :confirmation_token_created_at, :datetime
  end
end
