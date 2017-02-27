class RemoveSkillsFromSubmission < ActiveRecord::Migration
  def change
    remove_column :submissions, :html
    remove_column :submissions, :css
    remove_column :submissions, :js
    remove_column :submissions, :ror
    remove_column :submissions, :db
    remove_column :submissions, :programming_others
  end
end
