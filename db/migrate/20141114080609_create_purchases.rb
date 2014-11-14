class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.string :recipient
      t.string :country
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :postcode
      t.string :phonenumber

      t.string :status, default: "ordering" # "prepay", "paid", "shipping"

      t.timestamps
    end
  end
end
