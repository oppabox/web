class Order < ActiveRecord::Base
  belongs_to  :item
  belongs_to  :purchase
  has_many    :order_option_items
end
