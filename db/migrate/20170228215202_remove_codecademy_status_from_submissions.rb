class RemoveCodecademyStatusFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :codecademy_status
  end
end
