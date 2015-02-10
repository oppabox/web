class AddReferenceNumberIndexToPurchases < ActiveRecord::Migration
  def change
  	add_index :purchases, :reference_number, { unique: true }
  end
end
