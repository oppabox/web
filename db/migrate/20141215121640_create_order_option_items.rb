class CreateOrderOptionItems < ActiveRecord::Migration
  def change
    create_table :order_option_items do |t|
      t.integer   :order_id
      t.integer   :option_item_id, :default => -1
      t.integer   :option_id
      t.string    :option_text

      t.timestamps
    end
  end
end
