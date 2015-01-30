class OrderShipping < ActiveRecord::Base
	belongs_to	:order
	belongs_to	:shipping
end
