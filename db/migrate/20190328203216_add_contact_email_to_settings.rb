class AddContactEmailToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :contact_email, :text
  end
end
