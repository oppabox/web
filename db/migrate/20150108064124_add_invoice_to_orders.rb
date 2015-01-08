class AddInvoiceToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :invoice, :string
  end
end
