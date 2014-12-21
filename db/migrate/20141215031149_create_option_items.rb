class CreateOptionItems < ActiveRecord::Migration
  def change
    create_table :option_items do |t|
      t.integer     :option_id
      t.integer     :price_change,  :default => 0
      t.string      :name

      t.integer     :quantity,    :default => 1
      t.boolean     :limited,     :default => false

      t.timestamps
    end
  end
end
