class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer     :user_id,   :null => false

      t.string      :addr_1
      t.string      :addr_2
      t.string      :addr_3

      t.string      :postcode

      t.timestamps
    end
  end
end
