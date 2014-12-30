def kitchenbox
#KITCHEN BOX
  b = Box.where(:path => "kitchen_box").first

#FRYPAN
  i = Item.new
    i.box = b
    i.path = "frypan"
    i.original_price = "345290"
    i.sale_price = "225000"
    i.quantity = -1
    i.limited = false
		i.weight = 5.0
  i.save

#FRYPAN : LOCALE NAME
  name = {"ko" => "프라이팬", "en" => "Frypan", "cn" => "Frypan", "ja" => "Frypan"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#KITCHENTOOL
  i = Item.new
    i.box = b
    i.path = "kitchentool"
    i.original_price = "90850"
    i.sale_price = "55000"
    i.quantity = -1
    i.limited = false
		i.weight = 1.0
  i.save

#KITCHENTOOL : LOCALE NAME
  name = {"ko" => "키친툴", "en" => "Kitchen Tool", "cn" => "Kitchen Tool", "ja" => "Kitchen Tool"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end
#PALACE
  i = Item.new
    i.box = b
    i.path = "palace"
    i.original_price = "181320"
    i.sale_price = "135000"
    i.quantity = -1
    i.limited = false
		i.weight = 4.0
  i.save

#PALACE : LOCALE NAME
  name = {"ko" => "팰러스", "en" => "Palace", "cn" => "Palace", "ja" => "Palace"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#ARCHI
  i = Item.new
    i.box = b
    i.path = "archi"
    i.original_price = "114810"
    i.sale_price = "86500"
    i.quantity = -1
    i.limited = false
		i.weight = 2.0
  i.save

#ARCHI : LOCALE NAME
  name = {"ko" => "아키", "en" => "Archi", "cn" => "Archi", "ja" => "Archi"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#GOCCIA
  i = Item.new
    i.box = b
    i.path = "goccia"
    i.original_price = "182220"
    i.sale_price = "125000"
    i.quantity = -1
    i.limited = false
		i.weight = 2.5
  i.save

#GOCCIA : LOCALE NAME
  name = {"ko" => "고씨아", "en" => "Goccia", "cn" => "Goccia", "ja" => "Goccia"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#TULIPANI
  i = Item.new
    i.box = b
    i.path = "tulipani"
    i.original_price = "103330"
    i.sale_price = "85000"
    i.quantity = -1
    i.limited = false
		i.weight = 2.0
  i.save

#TULIPANI : LOCALE NAME
  name = {"ko" => "튤리파니", "en" => "Tulipani", "cn" => "Tulipani", "ja" => "Tulipani"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#OLIVIA
  i = Item.new
    i.box = b
    i.path = "olivia"
    i.original_price = "211900"
    i.sale_price = "155000"
    i.quantity = -1
    i.limited = false
		i.weight = 4.0
  i.save

#OLIVIA : LOCALE NAME
  name = {"ko" => "올리비아", "en" => "Olivia", "cn" => "Olivia", "ja" => "Olivia"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#SWING
  i = Item.new
    i.box = b
    i.path = "swing"
    i.original_price = "210770"
    i.sale_price = "155000"
    i.quantity = -1
    i.limited = false
		i.weight = 4.0
  i.save

#SWING : LOCALE NAME
  name = {"ko" => "스윙", "en" => "Swing", "cn" => "Swing", "ja" => "Swing"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#SYNTHESIS
  i = Item.new
    i.box = b
    i.path = "synthesis"
    i.original_price = "169640"
    i.sale_price = "135000"
    i.quantity = -1
    i.limited = false
		i.weight = 4.0
  i.save

#SYNTHESIS : LOCALE NAME
  name = {"ko" => "신테시스", "en" => "Synthesis", "cn" => "Synthesis", "ja" => "Synthesis"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

end
