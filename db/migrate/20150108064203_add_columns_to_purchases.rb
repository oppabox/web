class AddColumnsToPurchases < ActiveRecord::Migration
  def change
  	add_column :purchases, :reference_number, :string
  	add_column :purchases, :pay_option, :integer
  end
end
