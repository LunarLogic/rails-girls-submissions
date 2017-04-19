class AddRejectionReasonToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :rejection_reason, :string
  end
end
