class Option < ActiveRecord::Base
  belongs_to    :item
  has_many      :option_items
end
