class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.string :recipient
      t.string :country
      t.string :city
      t.string :state
      t.string :address
      t.string :postcode
      t.string :phonenumber

      t.string :status, default: "ordering" # "paid", "shipping"

      # 결제 완료 후
      t.string :replycd
      t.string :replymsg
      t.string :order_no
      t.string :amt
      t.string :pay_type
      t.string :approval_ymdhms
      t.string :seq_no

      t.timestamps
    end
  end
end
