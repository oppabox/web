class CreateShippings < ActiveRecord::Migration
  def change
    create_table :shippings do |t|
    	t.integer :category, null: false, default: 0
    	t.string :name
      t.timestamps
    end
  end
end
