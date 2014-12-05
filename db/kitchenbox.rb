def kitchenbox
#KITCHEN BOX
  b = Box.where(:path => "kitchen_box").first

#FRYPAN
  i = Item.new
    i.box = b
    i.path = "frypan"
    i.logo_path = "/images/items/kitchen_box/frypan/thumbnail.jpg"
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

#FRYPAN : IMAGES
  1.upto(2) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/kitchen_box/frypan/#{x}.jpg"
    m.save
  end
# #en
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/kitchen_box/frypan/en/1.jpg"
# m.save
# #ja
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/kitchen_box/frypan/ja/1.jpg"
# m.save
# #zh
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/kitchen_box/frypan/zh/1.jpg"
# m.save

#KITCHENTOOL
  i = Item.new
    i.box = b
    i.path = "kitchentool"
    i.logo_path = "/images/items/kitchen_box/kitchentool/thumb.jpg"
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

#KITCHENTOOL : IMAGES
  0.upto(8) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/kitchen_box/kitchentool/#{x}.jpg"
    m.save
  end
# #en
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/kitchen_box/kitchentool/en/1.jpg"
# m.save
# #ja
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/kitchen_box/kitchentool/ja/1.jpg"
# m.save
# #zh
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/kitchen_box/kitchentool/zh/1.jpg"
# m.save

#WESTERN TABLEWARE
#ARCHI
  i = Item.new
    i.box = b
    i.path = "archi"
    i.logo_path = "/images/items/kitchen_box/tableware/table1/archi/thumb.jpg"
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

#ARCHI : IMAGES
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/kitchen_box/tableware/table1/archi/main.jpg"
  m.save

#GOCCIA
  i = Item.new
    i.box = b
    i.path = "goccia"
    i.logo_path = "/images/items/kitchen_box/tableware/table1/goccia/thumb.jpg"
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

#GOCCIA : IMAGES
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/kitchen_box/tableware/table1/goccia/main.jpg"
  m.save

#OLIVIA
  i = Item.new
    i.box = b
    i.path = "olivia"
    i.logo_path = "/images/items/kitchen_box/tableware/table2/olivia/thumb.jpg"
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

#OLIVIA : IMAGES
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/kitchen_box/tableware/table2/olivia/main.jpg"
  m.save

#PALACE
  i = Item.new
    i.box = b
    i.path = "palace"
    i.logo_path = "/images/items/kitchen_box/tableware/table2/palace/thumb.jpg"
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

#PALACE : IMAGES
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/kitchen_box/tableware/table2/palace/main.jpg"
  m.save

#SWING
  i = Item.new
    i.box = b
    i.path = "swing"
    i.logo_path = "/images/items/kitchen_box/tableware/table2/swing/thumb.jpg"
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

#SWING : IMAGES
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/kitchen_box/tableware/table2/swing/main.jpg"
  m.save

#SYNTHESIS
  i = Item.new
    i.box = b
    i.path = "synthesis"
    i.logo_path = "/images/items/kitchen_box/tableware/table2/synthesis/thumb.jpg"
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

#SYNTHESIS : IMAGES
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/kitchen_box/tableware/table2/synthesis/main.jpg"
  m.save

#TULIPANI
  i = Item.new
    i.box = b
    i.path = "tulipani"
    i.logo_path = "/images/items/kitchen_box/tableware/table1/tulipani/thumb.jpg"
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

#TULIPANI : IMAGES
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/kitchen_box/tableware/table1/tulipani/main.jpg"
  m.save

end
