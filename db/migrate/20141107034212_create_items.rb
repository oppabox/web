class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer     :box_id
      t.string      :path

      t.integer     :original_price
      t.integer     :sale_price
      t.boolean     :show_original_price

      t.integer     :quantity,    :default => -1
      t.boolean     :limited,     :default => false
      t.boolean     :periodic,    :default => false
      t.boolean     :opened,      :default => true
      t.float       :weight,      :null => false

      t.integer     :buy_limit,   :default => 20

      t.timestamps
    end
  end
end
