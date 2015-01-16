class CreateCancels < ActiveRecord::Migration
  def change
    create_table :cancels do |t|
    	t.integer			:order_id
    	t.integer			:quantity, :null => false, :default => 0
    	t.integer			:status, :null => false, :default => 0
    	t.integer			:reason, :default => 0
    	t.string			:reason_details

      t.timestamps
    end
  end
end
