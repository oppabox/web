class CreateOrderShippings < ActiveRecord::Migration
  def change
    create_table :order_shippings do |t|
    	t.belongs_to :order, index: true
    	t.belongs_to :shipping, index: true
      t.timestamps
    end
  end
end
