class AddDeletedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :deleted, :boolean, default: false
  end
end
