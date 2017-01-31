class AddConfirmationFieldsToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :confirmation_token, :string
    add_column :submissions, :confirmation_token_created_at, :datetime
  end
end
