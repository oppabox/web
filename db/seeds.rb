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
#이민호박스

#JEWELRY BOX
b = Box.where(:path => "jewelry_box").first
#SET 1
#SET 2
#SET 3
#SET 4
#SET 5

#BEAUTY BOX
#SET 1 : BASIC INFO
b = Box.where(:path => "beauty_box").first
i = Item.new
  i.box = b
  i.path = "skinrx1"
  i.logo_path = "/items/beauty_box/skinrx/set1/logo.jpg"
  i.original_price = "52000"
  i.sale_price = "50000"
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
m.path = "/items/beauty_box/skinrx/set1/1.jpg"
m.save

#SET 1 : OPTIONS
#NONE

#SET 2
i = Item.new
  i.box = b
  i.path = "skinrx2"
  i.logo_path = "/items/beauty_box/skinrx/set2/logo.jpg"
  i.original_price = "116500"
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
m.path = "/items/beauty_box/skinrx/set2/1.jpg"
m.save

#SET 2 : OPTIONS
#NONE

#SET 3
i = Item.new
  i.box = b
  i.path = "skinrx3"
  i.logo_path = "/items/beauty_box/skinrx/set3/logo.jpg"
  i.original_price = "126000"
  i.sale_price = "95000"
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
m.path = "/items/beauty_box/skinrx/set3/1.jpg"
m.save

#SET 3 : OPTIONS
#NONE

#SET 4
i = Item.new
  i.box = b
  i.path = "skinrx4"
  i.logo_path = "/items/beauty_box/skinrx/set4/logo.jpg"
  i.original_price = "157000"
  i.sale_price = "99000"
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
m.path = "/items/beauty_box/skinrx/set4/1.jpg"
m.save

#SET 4 : OPTIONS
#NONE

#DESIGN BOX
b = Box.where(:path => "design_box").first

#KITCHEN BOX
b = Box.where(:path => "kitchen_box").first
