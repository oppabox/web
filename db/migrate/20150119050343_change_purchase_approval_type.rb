class ChangePurchaseApprovalType < ActiveRecord::Migration
  def change
  	change_table :purchases do |t|
  		t.rename :approval_ymdhms, :approval_datetime
  		t.change :approval_datetime, :datetime
  	end
  end
end
