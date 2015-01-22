class AddReturnIdToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :return_id, :integer
  end
end
