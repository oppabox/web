class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer     :box_id
      t.string      :path

      t.integer     :original_price
      t.integer     :sale_price
      t.boolean     :show_original_price

      t.integer     :quantity
      t.boolean     :limited,     :default => false

      t.timestamps
    end
  end
end
