# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["STAR BOX", "JEWELRY BOX", "BEAUTY BOX", "DESIGN BOX", "KITCHEN BOX"].each do |x|
  Box.create(display_name: x, path: x.gsub(" ", "_").downcase )
end

#STAR BOX
b = Box.where(:path => "star_box").first

#김재중박스
i = Item.new
  i.box = b
  i.path = "jj"
  i.logo_path = "/images/items/star_box/jj/jj.jpg"
  i.original_price = "227000"
  i.sale_price = "58000"
  i.quantity = -1
  i.limited = true
i.save

#김재중박스 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "김재중"
n.save

#김재중박스 : IMAGES
1.upto(2) do |x|
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/star_box/jj/#{x}.jpg"
  m.save
end

#이민호박스
i = Item.new
  i.box = b
  i.path = "minho"
  i.logo_path = "/images/items/star_box/minho/minho.jpg"
  i.original_price = "71500"  #EXO BACK : 19,500
                              #SNAP BACK : 32,500
                              #PHOTO BOOK : 19,530          전부 표기 해주세요.
  i.sale_price = "53000"
  i.quantity = -1
  i.limited = true
i.save

#이민호박스 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "이민호"
n.save

#이민호박스 : IMAGES
1.upto(4) do |x|
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/star_box/minho/#{x}.jpg"
  m.save
end

#JEWELRY BOX
#SET 1
b = Box.where(:path => "jewelry_box").first
i = Item.new
  i.box = b
  i.path = "cross"
  i.logo_path = "/images/items/jewelry_box/cross/cross.jpg"
  i.original_price = "250000"
  i.sale_price = "89000"
  i.show_original_price = true
  i.quantity = -1
  i.limited = false
i.save

#SET 1 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "925 실버 크로스 이니셜팔찌"
n.save

#SET 1 : IMAGES
1.upto(3) do |x|
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/jewelry_box/cross/#{x}.jpg"
  m.save
end

#SET 1 : OPTIONS
#원하는 레터링(영문 대문자 이니셜)가능
#각인 : true, false

#SET 2
b = Box.where(:path => "jewelry_box").first
i = Item.new
  i.box = b
  i.path = "knot"
  i.logo_path = "/images/items/jewelry_box/knot/knot.jpg"
  i.original_price = "113000"
  i.sale_price = "49000"
  i.show_original_price = true
  i.quantity = -1
  i.limited = false
i.save

#SET 2 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "925 실버 매듭 셋트"
n.save

#SET 2 : IMAGES
1.upto(3) do |x|
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/jewelry_box/knot/#{x}.jpg"
  m.save
end

#SET 2 : OPTIONS
#NONE

#SET 3
b = Box.where(:path => "jewelry_box").first
i = Item.new
  i.box = b
  i.path = "ring"
  i.logo_path = "/images/items/jewelry_box/ring/thumb.jpg"
  i.original_price = "69000"
  i.sale_price = "49000"
  i.show_original_price = true
  i.quantity = -1
  i.limited = false
i.save

#SET 3 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "Cubic brass ring"
n.save

#SET 3 : IMAGES
1.upto(3) do |x|
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/jewelry_box/ring/#{x}.jpg"
  m.save
end

#SET 3 : OPTIONS
#사이즈 옵션표 확인 후 추가

#BEAUTY BOX
#SET 1 : BASIC INFO
b = Box.where(:path => "beauty_box").first
i = Item.new
  i.box = b
  i.path = "set1"
  i.logo_path = "/images/items/beauty_box/set1/logo.jpg"
  i.original_price = "52500"
  i.sale_price = "48500"
  i.show_original_price = true
  i.quantity = -1
  i.limited = false
i.save

#SET 1 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "피부 진정 & 보습세트"
n.save

#SET 1 : IMAGES
m = ItemImage.new
m.item = i
m.path = "/images/items/beauty_box/set1/1.jpg"
m.save

#SET 1 : OPTIONS
#NONE

#SET 2
i = Item.new
  i.box = b
  i.path = "set2"
  i.logo_path = "/images/items/beauty_box/set2/logo.jpg"
  i.original_price = "116000"
  i.sale_price = "79000"
  i.show_original_price = true
  i.quantity = -1
  i.limited = false
i.save

#SET 2 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "스킨 브라이트닝 세트"
n.save

#SET 2 : IMAGES
m = ItemImage.new
m.item = i
m.path = "/images/items/beauty_box/set2/1.jpg"
m.save

#SET 2 : OPTIONS
#NONE

#SET 3
i = Item.new
  i.box = b
  i.path = "set3"
  i.logo_path = "/images/items/beauty_box/set3/logo.jpg"
  i.original_price = "126000"
  i.sale_price = "92500"
  i.show_original_price = true
  i.quantity = -1
  i.limited = false
i.save

#SET 3 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "뷰티버라이어티 세트"
n.save

#SET 3 : IMAGES
m = ItemImage.new
m.item = i
m.path = "/images/items/beauty_box/set3/1.jpg"
m.save

#SET 3 : OPTIONS
#NONE

#SET 4
i = Item.new
  i.box = b
  i.path = "set4"
  i.logo_path = "/images/items/beauty_box/set4/logo.jpg"
  i.original_price = "157000"
  i.sale_price = "98500"
  i.show_original_price = true
  i.quantity = -1
  i.limited = false
i.save

#SET 4 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "월드 베스트 세트"
n.save

#SET 4 : IMAGES
m = ItemImage.new
m.item = i
m.path = "/images/items/beauty_box/set4/1.jpg"
m.save


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

#IN MY BAG 6 : OPTIONS
#NONE


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
m = ItemImage.new
m.item = i
m.path = "/images/items/kitchen_box/frypan/frypan.jpg"
m.save


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

#WESTERN TABLEWARE
#ARCHI
i = Item.new
  i.box = b
  i.path = "archi"
  i.logo_path = "/images/items/kitchen_box/tableware/archi/thumb.jpg"
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
m.path = "/images/items/kitchen_box/tableware/archi/main.jpg"
m.save

#GOCCIA
i = Item.new
  i.box = b
  i.path = "goccia"
  i.logo_path = "/images/items/kitchen_box/tableware/goccia/thumb.jpg"
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
m.path = "/images/items/kitchen_box/tableware/goccia/main.jpg"
m.save

#OLIVIA
i = Item.new
  i.box = b
  i.path = "olivia"
  i.logo_path = "/images/items/kitchen_box/tableware/olivia/thumb.jpg"
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
m.path = "/images/items/kitchen_box/tableware/olivia/main.jpg"
m.save

#PALACE
i = Item.new
  i.box = b
  i.path = "palace"
  i.logo_path = "/images/items/kitchen_box/tableware/palace/thumb.jpg"
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
m.path = "/images/items/kitchen_box/tableware/palace/main.jpg"
m.save

#SWING
i = Item.new
  i.box = b
  i.path = "swing"
  i.logo_path = "/images/items/kitchen_box/tableware/swing/thumb.jpg"
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
m.path = "/images/items/kitchen_box/tableware/swing/main.jpg"
m.save

#SYNTHESIS
i = Item.new
  i.box = b
  i.path = "synthesis"
  i.logo_path = "/images/items/kitchen_box/tableware/synthesis/thumb.jpg"
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
m.path = "/images/items/kitchen_box/tableware/synthesis/main.jpg"
m.save

#TULIPANI
i = Item.new
  i.box = b
  i.path = "tulipani"
  i.logo_path = "/images/items/kitchen_box/tableware/tulipani/thumb.jpg"
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
m.path = "/images/items/kitchen_box/tableware/tulipani/main.jpg"
m.save

