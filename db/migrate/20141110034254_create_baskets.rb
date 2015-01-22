class CreateBaskets < ActiveRecord::Migration
  def change
    create_table :baskets do |t|
      t.integer :item_id
      t.integer :user_id

      t.boolean :deleted,   :default => false

      t.timestamps
    end
  end
end
