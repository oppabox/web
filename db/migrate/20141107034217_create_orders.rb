class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer     :item_id
      t.integer     :quantity
      t.integer     :user_id

      t.string      :address_1
      t.string      :address_2
      t.string      :address_3
      t.string      :postcode
      t.string      :phone_number

      t.string      :comment

      t.timestamps
    end
  end
end
