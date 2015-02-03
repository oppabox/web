class ItemShipping < ActiveRecord::Base
	belongs_to :item
	belongs_to :shipping
end
