def designbox
#DESIGN BOX
  b = Box.where(:path => "design_box").first
#IN MY BAG 1
  i = Item.new
    i.box = b
    i.path = "in_my_bag_1"
    i.original_price = "51300"
    i.sale_price = "48500"
  i.save

#IN MY BAG 1 : LOCALE NAME
  name = {"ko" => "In My Bag #1", "en" => "In My Bag #1", "cn" => "In My Bag #1", "ja" => "In My Bag #1"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 1 :OPTIONS
#Mirror
  o = Option.new
    o.title = "Mirror"
    o.option_type = 1
    o.item = i
  o.save

  {"Navy" => "0", "Green" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Pouch
  o = Option.new
    o.title = "Pouch"
    o.option_type = 1
    o.item = i
  o.save

  {"Dot" => "0", "Blue/Yello" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end

#IN MY BAG 2
  i = Item.new
    i.box = b
    i.path = "in_my_bag_2"
    i.original_price = "56300"
    i.sale_price = "50500"
  i.save

#IN MY BAG 1 : LOCALE NAME
  name = {"ko" => "In My Bag #2", "en" => "In My Bag #2", "cn" => "In My Bag #2", "ja" => "In My Bag #2"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 1 : OPTIONS
#Mirror
  o = Option.new
    o.title = "Mirror"
    o.option_type = 1
    o.item = i
  o.save

  {"Orange" => "0", "White" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Pouch
  o = Option.new
    o.title = "Pouch"
    o.option_type = 1
    o.item = i
  o.save

  {"Red" => "0", "Green" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Socks
  o = Option.new
    o.title = "Socks"
    o.option_type = 1
    o.item = i
  o.save

  {"Charcoal Argyle" => "0", "Cotton Argyle" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end

#IN MY BAG 3
  i = Item.new
    i.box = b
    i.path = "in_my_bag_3"
    i.original_price = "70800"
    i.sale_price = "67500"
  i.save

#IN MY BAG 3 : LOCALE NAME
  name = {"ko" => "In My Bag #3", "en" => "In My Bag #3", "cn" => "In My Bag #3", "ja" => "In My Bag #3"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 3 : OPTIONS
#Pouch
  o = Option.new
    o.title = "Pouch"
    o.option_type = 1
    o.item = i
  o.save

  {"Dot" => "0", "Blue/Yello" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Line Tale
  o = Option.new
    o.title = "Line Tale"
    o.option_type = 1
    o.item = i
  o.save

  {"Pink" => "0", "Orange" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Clutch
  o = Option.new
    o.title = "Clutch"
    o.option_type = 1
    o.item = i
  o.save

  {"Blue" => "0", "Black" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end

#IN MY BAG 4
  i = Item.new
    i.box = b
    i.path = "in_my_bag_4"
    i.original_price = "70800"
    i.sale_price = "63500"
  i.save

#IN MY BAG 4 : LOCALE NAME
  name = {"ko" => "In My Bag #4", "en" => "In My Bag #4", "cn" => "In My Bag #4", "ja" => "In My Bag #4"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 4 : OPTIONS
#Pouch
  o = Option.new
    o.title = "Pouch"
    o.option_type = 1
    o.item = i
  o.save

  {"Pollen-orange5" => "0", "Pollen-green5" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Line Tale
  o = Option.new
    o.title = "Line Tale"
    o.option_type = 1
    o.item = i
  o.save

  {"Pink" => "0", "Orange" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Clutch
  o = Option.new
    o.title = "Clutch"
    o.option_type = 1
    o.item = i
  o.save

  {"Blue" => "0", "Black" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end

#IN MY BAG 5
  i = Item.new
    i.box = b
    i.path = "in_my_bag_5"
    i.original_price = "100800"
    i.sale_price = "91000"
  i.save

#IN MY BAG 5 : LOCALE NAME
  name = {"ko" => "In My Bag #5", "en" => "In My Bag #5", "cn" => "In My Bag #5", "ja" => "In My Bag #5"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 5 : OPTIONS
#Leather Bag
  o = Option.new
    o.title = "Leather Bag"
    o.option_type = 1
    o.item = i
  o.save

  {"Navy" => "0", "Blue" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Note Book
  o = Option.new
    o.title = "Note Book"
    o.option_type = 1
    o.item = i
  o.save

  {"White" => "0", "Blue" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end

#IN MY BAG 6
  i = Item.new
    i.box = b
    i.path = "in_my_bag_6"
    i.original_price = "111000"
    i.sale_price = "94500"
  i.save

#IN MY BAG 6 : LOCALE NAME
  name = {"ko" => "In My Bag #6", "en" => "In My Bag #6", "cn" => "In My Bag #6", "ja" => "In My Bag #6"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#IN MY BAG 6 : OPTIONS
#Leather Bag
  o = Option.new
    o.title = "Leather Bag"
    o.option_type = 1
    o.item = i
  o.save

  {"Navy" => "0", "Blue" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Clutch
  o = Option.new
    o.title = "Clutch"
    o.option_type = 1
    o.item = i
  o.save

  {"Blue" => "0", "Black" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Socks select #1
  o = Option.new
    o.title = "Socks select #1"
    o.option_type = 1
    o.item = i
  o.save

  {"Stripe Navy" => "0", "Stripe Charcoal" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
#Socks select #2
  o = Option.new
    o.title = "Socks select #2"
    o.option_type = 1
    o.item = i
  o.save

  {"Waled Pink" => "0", "Waled Black" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
end
