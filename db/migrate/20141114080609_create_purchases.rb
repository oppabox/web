class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.string :recipient

      t.string :city
      t.string :state
      t.string :address
      t.string :postcode
      t.string :phonenumber

      t.integer :status, default: 0 # 0=>"purchase_ordering" 1=>"purchase_paid" 2=>"purchase_pending"

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
