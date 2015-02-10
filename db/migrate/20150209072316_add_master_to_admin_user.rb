class AddMasterToAdminUser < ActiveRecord::Migration
  def change
  	add_column :admin_users, :master, :boolean, index: true, default: false
  end
end
