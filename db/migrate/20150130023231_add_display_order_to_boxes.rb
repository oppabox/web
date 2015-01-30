class AddDisplayOrderToBoxes < ActiveRecord::Migration
  def change
  	add_column :boxes, :display_order, :integer, index: true, default: 0
  end
end
