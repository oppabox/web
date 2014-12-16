class Option < ActiveRecord::Base
  belongs_to    :item
  has_many      :option_items
  has_many      :order_option_items
end
