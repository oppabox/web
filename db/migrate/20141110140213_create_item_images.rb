class CreateItemImages < ActiveRecord::Migration
  def change
    create_table :item_images do |t|
      t.integer     :item_id
      t.string      :path

      t.timestamps
    end
  end
end
