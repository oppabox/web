class OptionItem < ActiveRecord::Base
  belongs_to  :option
  has_many    :order_option_items
end
