class RemoveConfirmedFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :confirmed, :boolean
  end
end
