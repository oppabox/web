class OrderOptionItem < ActiveRecord::Base
  belongs_to  :order
  belongs_to  :option_item
  belongs_to  :option

  validate :option_validate

  def option_validate
    order = Order.where(:id => self.order_id).take
    option = Option.where(:id => self.option_id).take

    if order.item != option.item #1
      errors.add(:order_error, "input error")
    end

    if option.option_type == 1 #2
      oi = OptionItem.where(:id => self.option_item_id).take
      if oi.option != option
        errors.add(:order_item_error, "input error")
      end
    end
  end
end
