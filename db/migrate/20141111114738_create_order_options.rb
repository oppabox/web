class CreateOrderOptions < ActiveRecord::Migration
  def change
    create_table :order_options do |t|
      t.integer     :option_id
      t.integer     :order_id
      t.string      :option_comment

      t.timestamps
    end
  end
end
