class RemoveReturnIdFromOrder < ActiveRecord::Migration
  def change
  	remove_column :orders, :return_id, :integer
  end
end
