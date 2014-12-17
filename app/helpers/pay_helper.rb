module PayHelper
  def option_string order
    order.inspect
    option_array = Array.new
    order.order_option_items.each do |x| 
      option = x.option
      option_description = ""
      if option.option_type == 1
        option_description = [option.title, x.option_item.name].join(" : ")
      else
        option_description = [option.title, x.option_text].join(" : ")
      end
      option_array << option_description
    end
    option_array.join(", ")
  end
end
