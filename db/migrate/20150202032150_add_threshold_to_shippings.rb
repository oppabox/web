class AddThresholdToShippings < ActiveRecord::Migration
  def change
  	add_column :shippings, :threshold, :integer
  end
end
