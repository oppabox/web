def grienichbox
#BEAUTY BOX
#BOX 1 : BASIC INFO
b = Box.where(:path => "grienich_box").first
  i = Item.new
    i.box = b
    i.path = "box1"
    i.original_price = "94800"
    i.sale_price = "78000"
    i.show_original_price = true
    i.quantity = -1
    i.limited = false
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

#BOX 2 : BASIC INFO
b = Box.where(:path => "grienich_box").first
  i = Item.new
    i.box = b
    i.path = "box2"
    i.original_price = "98000"
    i.sale_price = "121400"
    i.show_original_price = true
    i.quantity = -1
    i.limited = false
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

#BOX 3 : BASIC INFO
b = Box.where(:path => "grienich_box").first
  i = Item.new
    i.box = b
    i.path = "box3"
    i.original_price = "15800"
    i.sale_price = "191400"
    i.show_original_price = true
    i.quantity = -1
    i.limited = false
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

end