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
  i.save

#FRYPAN : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "Frypan"
  n.save


#KITCHENTOOL
  i = Item.new
    i.box = b
    i.path = "kitchentool"
    i.original_price = "90850"
    i.sale_price = "55000"
    i.quantity = -1
    i.limited = false
  i.save

#KITCHENTOOL : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "KitchenTool"
  n.save

#WESTERN TABLEWARE
#ARCHI
  i = Item.new
    i.box = b
    i.path = "archi"
    i.original_price = "114810"
    i.sale_price = "86500"
    i.quantity = -1
    i.limited = false
  i.save

#ARCHI : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "Archi"
  n.save

#GOCCIA
  i = Item.new
    i.box = b
    i.path = "goccia"
    i.original_price = "182220"
    i.sale_price = "125000"
    i.quantity = -1
    i.limited = false
  i.save

#GOCCIA : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "Goccia"
  n.save


#OLIVIA
  i = Item.new
    i.box = b
    i.path = "olivia"
    i.original_price = "211900"
    i.sale_price = "155000"
    i.quantity = -1
    i.limited = false
  i.save

#OLIVIA : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "Olivia"
  n.save


#PALACE
  i = Item.new
    i.box = b
    i.path = "palace"
    i.original_price = "181320"
    i.sale_price = "135000"
    i.quantity = -1
    i.limited = false
  i.save

#PALACE : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "Palace"
  n.save


#SWING
  i = Item.new
    i.box = b
    i.path = "swing"
    i.original_price = "210770"
    i.sale_price = "155000"
    i.quantity = -1
    i.limited = false
  i.save

#SWING : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "Swing"
  n.save

#SYNTHESIS
  i = Item.new
    i.box = b
    i.path = "synthesis"
    i.original_price = "169640"
    i.sale_price = "135000"
    i.quantity = -1
    i.limited = false
  i.save

#SYNTHESIS : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "Synthesis"
  n.save

#TULIPANI
  i = Item.new
    i.box = b
    i.path = "tulipani"
    i.original_price = "103330"
    i.sale_price = "85000"
    i.quantity = -1
    i.limited = false
  i.save

#TULIPANI : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "Tulipani"
  n.save

end
