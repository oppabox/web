include ActionView::Helpers::NumberHelper
class Order < ActiveRecord::Base
  belongs_to  :item
  belongs_to  :purchase
  has_many    :order_option_items

  before_save :period_check

  def period_check
    if ![1,3,6,12].include? self.order_periodic
      self.order_periodic = 1
    end
  end

  def self.change_currency money
    "#{number_with_delimiter(money)} KRW (#{number_with_delimiter((money.to_f / CURRENCY).round(2))} USD)".html_safe
  end

  def total_price
    sum = self.item.sale_price 
    self.order_option_items.each do |x|
      if !x.option_item_id.nil? and x.option_item_id > 0 
        sum += x.option_item.price_change
      end
    end
    sum * self.order_periodic
  end
end
