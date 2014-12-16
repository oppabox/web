class OrderOptionItem < ActiveRecord::Base
  belongs_to  :order
  belongs_to  :option_item
  belongs_to  :option

  before_save :option_validate

  def option_validate
    puts self.order_id
    puts self.option_item_id
    puts self.option_id
    puts self.option_text
    puts "HIHI****************************"
    puts "HIHI****************************"
    puts "HIHI****************************"
    puts "HIHI****************************"
    puts "HIHI****************************"
    puts "HIHI****************************"
    puts "HIHI****************************"
    puts "HIHI****************************"
    puts "HIHI****************************"
    puts "HIHI****************************"
    puts "HIHI****************************"
  end
end
