class RemoveDeletedFromOrders < ActiveRecord::Migration
  def change
  	remove_column :orders, :deleted, :boolean
  end
end
