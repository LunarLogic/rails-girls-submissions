class RemoveCodecademyColumnsFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :codecademy_username, :string
    remove_column :submissions, :codecademy_status, :boolean
  end
end
