class RemoveAgeFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :age, :integer
  end
end
