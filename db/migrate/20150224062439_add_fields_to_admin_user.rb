class AddFieldsToAdminUser < ActiveRecord::Migration
  def change
  	add_column :admin_users, :registration_number, :string
  	add_column :admin_users, :representative, :string
  	add_column :admin_users, :phonenumber, :string
  	add_column :admin_users, :contact_email, :string
  end
end
