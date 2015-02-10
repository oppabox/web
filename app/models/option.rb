class Option < ActiveRecord::Base
  belongs_to    :item
  has_many      :option_items, :dependent => :destroy
  has_many      :order_option_items

  TYPE = {
    OPTION_TYPE_NORMAL => 'normal', 
    OPTION_TYPE_STRING => 'string'
  }
  TYPE_STRING_LOAD = {
    'normal' => "선택",
    'string' => "문자"
  }
end
