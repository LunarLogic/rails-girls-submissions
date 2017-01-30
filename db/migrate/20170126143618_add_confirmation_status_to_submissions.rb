class AddConfirmationStatusToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :confirmation_status, :integer, default: 0
  end
end
