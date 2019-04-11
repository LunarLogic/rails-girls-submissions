class AddGenderToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :gender, :string
  end
end
