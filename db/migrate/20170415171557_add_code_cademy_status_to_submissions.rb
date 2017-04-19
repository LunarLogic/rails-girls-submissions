class AddCodeCademyStatusToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :codecademy_status, :boolean
  end
end
