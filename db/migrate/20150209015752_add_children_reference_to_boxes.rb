class AddChildrenReferenceToBoxes < ActiveRecord::Migration
  def change
  	add_reference :boxes, :parent, index: true
  end
end
