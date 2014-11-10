class CreateItemNames < ActiveRecord::Migration
  def change
    create_table :item_names do |t|
      t.integer   :item_id
      t.string    :locale
      t.string    :name

      t.timestamps
    end
  end
end
