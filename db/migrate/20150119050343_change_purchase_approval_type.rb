class ChangePurchaseApprovalType < ActiveRecord::Migration
  def change
  	add_column :purchases, :approval_datetime, :datetime
  end
end
