class AddConfirmationFieldsToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :confirmed, :boolean
    add_column :submissions, :confirmation_token, :string
  end
end
