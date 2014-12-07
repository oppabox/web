def designbox
#DESIGN BOX
  b = Box.where(:path => "design_box").first
#IN MY BAG 1
  i = Item.new
    i.box = b
    i.path = "in_my_bag_1"
    i.original_price = "56300"
    i.sale_price = "50500"
    i.show_original_price = true
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 1 : LOCALE NAME
  name = {"ko" => "In My Bag 1", "en" => "In My Bag 1", "cn" => "In My Bag 1", "ja" => "In My Bag 1"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 1 : OPTIONS
#NONE

#IN MY BAG 2
  i = Item.new
    i.box = b
    i.path = "in_my_bag_2"
    i.original_price = "51300"
    i.sale_price = "48500"
    i.show_original_price = true
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 2 : LOCALE NAME
  name = {"ko" => "In My Bag 2", "en" => "In My Bag 2", "cn" => "In My Bag 2", "ja" => "In My Bag 2"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 2 :OPTIONS
#NONE

#IN MY BAG 3
  i = Item.new
    i.box = b
    i.path = "in_my_bag_3"
    i.original_price = "70800"
    i.sale_price = "67500"
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 3 : LOCALE NAME
  name = {"ko" => "In My Bag 3", "en" => "In My Bag 3", "cn" => "In My Bag 3", "ja" => "In My Bag 3"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 3 : OPTIONS
#NONE

#IN MY BAG 4
  i = Item.new
    i.box = b
    i.path = "in_my_bag_4"
    i.original_price = "70800"
    i.sale_price = "63500"
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 4 : LOCALE NAME
  name = {"ko" => "In My Bag 4", "en" => "In My Bag 4", "cn" => "In My Bag 4", "ja" => "In My Bag 4"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 4 : OPTIONS
#NONE

#IN MY BAG 5
  i = Item.new
    i.box = b
    i.path = "in_my_bag_5"
    i.original_price = "100800"
    i.sale_price = "91000"
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 5 : LOCALE NAME
  name = {"ko" => "In My Bag 5", "en" => "In My Bag 5", "cn" => "In My Bag 5", "ja" => "In My Bag 5"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end


#IN MY BAG 5 : OPTIONS
#NONE

#IN MY BAG 6
  i = Item.new
    i.box = b
    i.path = "in_my_bag_6"
    i.original_price = "111000"
    i.sale_price = "94500"
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 6 : LOCALE NAME
  name = {"ko" => "In My Bag 6", "en" => "In My Bag 6", "cn" => "In My Bag 6", "ja" => "In My Bag 6"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 6 : OPTIONS
#NONE
end
