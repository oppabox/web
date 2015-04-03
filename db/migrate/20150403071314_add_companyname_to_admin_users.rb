class AddCompanynameToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :company_name, :string
  end
end
