class AddAdultToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :adult, :boolean, default: false
  end
end
