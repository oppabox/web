def grienichbox
#BEAUTY BOX
#BOX 1 : BASIC INFO
b = Box.where(:path => "grienich_box").first
  i = Item.new
    i.box = b
    i.path = "box1"
    i.original_price = "94800"
    i.sale_price = "78000"
		i.weight = 4.0
  i.save

#BOX 1 : LOCALE NAME
  name = {"ko" => "Grienich Jersey (Pink, Blue)", "en" => "Grienich Jersey (Pink, Blue)", "cn" => "Grienich Jersey (Pink, Blue)", "ja" => "Grienich Jersey (Pink, Blue)"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end
#BOX 1 : OPTIONS
# Pink, Blue 선택
  o = Option.new
    o.title = "Color"
    o.option_type = 1
    o.item = i
  o.save

  {"No.81 PINK" => "0", "CROSS PRINT BLUE" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end

#BOX 2 : BASIC INFO
b = Box.where(:path => "grienich_box").first
  i = Item.new
    i.box = b
    i.path = "box2"
    i.original_price = "121400"
    i.sale_price = "98000"
		i.weight = 4.0
  i.save

#BOX 2 : LOCALE NAME
  name = {"ko" => "Grienich Eco set", "en" => "Grienich Eco set", "cn" => "Grienich Eco set", "ja" => "Grienich Eco set"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end
#BOX 2 : OPTIONS
# Warhol, Jobs 선택
  o = Option.new
    o.title = "Select"
    o.option_type = 1
    o.item = i
  o.save

  {"Set1" => "0", "Set2" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end

#BOX 3 : BASIC INFO
b = Box.where(:path => "grienich_box").first
  i = Item.new
    i.box = b
    i.path = "box3"
    i.original_price = "191400"
    i.sale_price = "158000"
		i.weight = 4.0
  i.save

#BOX 1 : LOCALE NAME
  name = {"ko" => "Grienich Clutch set", "en" => "Grienich Clutch set", "cn" => "Grienich Clutch set", "ja" => "Grienich Clutch set"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end
#BOX 3 : OPTIONS
# Pattern, Folding 선택
  o = Option.new
    o.title = "Select"
    o.option_type = 1
    o.item = i
  o.save

  {"Set1" => "0", "Set2" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end
end
