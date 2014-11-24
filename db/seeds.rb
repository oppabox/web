# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["JEWELRY BOX", "BEAUTY BOX"].each do |x|
  Box.create(display_name: x, path: x.gsub(" ", "_").downcase )
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

