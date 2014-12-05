def designbox
#DESIGN BOX
  b = Box.where(:path => "design_box").first
#IN MY BAG 1
  i = Item.new
    i.box = b
    i.path = "in_my_bag_1"
    i.logo_path = "/images/items/design_box/low1/thumb.jpg"
    i.original_price = "56300"
    i.sale_price = "50500"
    i.show_original_price = true
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 1 : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "In My Bag 1"
  n.save

#IN MY BAG 1 : IMAGES
  1.upto(9) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/design_box/low1/#{x}.jpg"
    m.save
  end
# #en
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/low1/en/bag1.jpg"
# m.save
# #ja
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/low1/ja/bag1.jpg"
# m.save
# #zh
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/low1/zh/bag1.jpg"
# m.save

#IN MY BAG 1 : OPTIONS
#NONE

#IN MY BAG 2
  i = Item.new
    i.box = b
    i.path = "in_my_bag_2"
    i.logo_path = "/images/items/design_box/low2/thumb.jpg"
    i.original_price = "51300"
    i.sale_price = "48500"
    i.show_original_price = true
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 2 : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "In My Bag 2"
  n.save

#IN MY BAG 2 : IMAGES
  1.upto(6) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/design_box/low2/#{x}.jpg"
    m.save
  end
# #en
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/low2/en/bag2.jpg"
# m.save
# #ja
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/low2/ja/bag2.jpg"
# m.save
# #zh
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/low2/zh/bag2.jpg"
# m.save

#IN MY BAG 2 :OPTIONS
#NONE

#IN MY BAG 3
  i = Item.new
    i.box = b
    i.path = "in_my_bag_3"
    i.logo_path = "/images/items/design_box/middle1/thumb.jpg"
    i.original_price = "70800"
    i.sale_price = "67500"
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 3 : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "In My Bag 3"
  n.save

#IN MY BAG 3 : IMAGES
  1.upto(10) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/design_box/middle1/#{x}.jpg"
    m.save
  end
# #en
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/middle1/en/bag3.jpg"
# m.save
# #ja
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/middle1/ja/bag3.jpg"
# m.save
# #zh
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/middle1/zh/bag3.jpg"
# m.save

#IN MY BAG 3 : OPTIONS
#NONE

#IN MY BAG 4
  i = Item.new
    i.box = b
    i.path = "in_my_bag_4"
    i.logo_path = "/images/items/design_box/middle2/thumb.jpg"
    i.original_price = "70800"
    i.sale_price = "63500"
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 4 : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "In My Bag 4"
  n.save

#IN MY BAG 4 : IMAGES
  1.upto(10) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/design_box/middle2/#{x}.jpg"
    m.save
  end
# #en
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/middle2/en/bag4.jpg"
# m.save
# #ja
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/middle2/ja/bag4.jpg"
# m.save
# #zh
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/middle2/zh/bag4.jpg"
# m.save

#IN MY BAG 4 : OPTIONS
#NONE

#IN MY BAG 5
  i = Item.new
    i.box = b
    i.path = "in_my_bag_5"
    i.logo_path = "/images/items/design_box/high1/thumb.jpg"
    i.original_price = "100800"
    i.sale_price = "91000"
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 5 : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "In My Bag 5"
  n.save

#IN MY BAG 5 : IMAGES
  1.upto(6) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/design_box/high1/#{x}.jpg"
    m.save
  end
# #en
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/high1/en/bag5.jpg"
# m.save
# #ja
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/high1/ja/bag5.jpg"
# m.save
# #zh
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/high1/zh/bag5.jpg"
# m.save

#IN MY BAG 5 : OPTIONS
#NONE

#IN MY BAG 6
  i = Item.new
    i.box = b
    i.path = "in_my_bag_6"
    i.logo_path = "/images/items/design_box/high2/thumb.jpg"
    i.original_price = "111000"
    i.sale_price = "94500"
    i.quantity = -1
    i.limited = false
  i.save

#IN MY BAG 6 : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "In My Bag 6"
  n.save

#IN MY BAG 6 : IMAGES
  1.upto(10) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/design_box/high2/#{x}.jpg"
    m.save
  end
# #en
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/high2/en/bag6.jpg"
# m.save
# #ja
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/high2/ja/bag6.jpg"
# m.save
# #zh
# m = ItemImage.new
# m.item = i
# m.path = "/images/items/design_box/high2/zh/bag6.jpg"
# m.save

#IN MY BAG 6 : OPTIONS
#NONE
end
