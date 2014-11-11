class CreateBaskets < ActiveRecord::Migration
  def change
    create_table :baskets do |t|

      t.timestamps
    end
  end
end
