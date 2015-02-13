class CreateGroupShippings < ActiveRecord::Migration
  def change
    create_table :group_shippings do |t|
    	t.string :name
    	t.integer :admin_user_id
      t.timestamps
    end
    add_column :items, :group_shipping_id, :integer, index: true
  end
end
