class AddAdminUserIdToBoxes < ActiveRecord::Migration
  def change
  	add_column :boxes, :admin_user_id, :integer, index: true
  end
end
