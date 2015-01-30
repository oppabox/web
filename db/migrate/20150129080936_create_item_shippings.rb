class CreateItemShippings < ActiveRecord::Migration
  def change
    create_table :item_shippings do |t|
    	t.belongs_to :item
    	t.belongs_to :shipping
      t.timestamps
    end
  end
end
