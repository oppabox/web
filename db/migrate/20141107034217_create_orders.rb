class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer     :purchase_id
      t.integer     :item_id
      t.integer     :quantity, :null => false, :default => 1
      t.integer     :order_periodic,    :default => 1

      t.boolean     :deleted, :default => false

      t.timestamps
    end
  end
end
