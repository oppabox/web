class AddPublicflagToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :public_flag, :boolean, default: false
  end
end
