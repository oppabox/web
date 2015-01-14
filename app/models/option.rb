class Option < ActiveRecord::Base
  belongs_to    :item
  has_many      :option_items
  has_many      :order_option_items

  TYPE = {
    OPTION_TYPE_NORMAL => 'normal', 
    OPTION_TYPE_STRING => 'string'
  }
end
