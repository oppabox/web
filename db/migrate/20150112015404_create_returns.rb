class CreateReturns < ActiveRecord::Migration
  def change
    create_table :returns do |t|
    	t.integer			:order_id
    	t.integer			:quantity, :null => false, :default => 0
    	t.integer			:status, :null => false, :default => 0
    	t.integer			:reason, :default => 0
    	t.string			:reason_details
    	
      t.string      :sender
    	t.string 			:phonenumber
      t.string 			:postcode
      t.string 			:address
      t.string 			:city
      t.string 			:state
      t.string      :country

      t.timestamps
    end
  end
end
