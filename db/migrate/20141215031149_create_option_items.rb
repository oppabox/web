class CreateOptionItems < ActiveRecord::Migration
  def change
    create_table :option_items do |t|
      t.integer     :option_id
      t.integer     :price_change,  :default => 0
      t.string      :name
      t.timestamps
    end
  end
end
