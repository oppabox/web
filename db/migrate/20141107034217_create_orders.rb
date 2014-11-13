class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer     :item_id
      t.integer     :quantity, :null => false, :default => 1
      t.integer     :user_id

      t.string      :country
      t.string      :address_1
      t.string      :address_2
      t.string      :address_3
      t.string      :postcode
      t.string      :phonenumber

      t.string      :comment

      t.timestamps
    end
  end
end
