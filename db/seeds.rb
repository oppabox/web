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
#LOW 1
i = Item.new
i.box = b
i.path = "design_low1"
i.logo_path = "/items/design_box/logo.jpg"
i.original_price = "56300"
i.sale_price = "52500"
i.show_original_price = true
i.quantity = -1
i.limited = false
i.save

#LOW 1 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "Low Price 1"
n.save

#LOW 1 : IMAGES
m = ItemImage.new
m.item = i
m.path = "/items/design_box/low1/1.jpg"
m.path = "/items/design_box/low1/2.jpg"
m.path = "/items/design_box/low1/3.jpg"
m.path = "/items/design_box/low1/4.jpg"
m.path = "/items/design_box/low1/5.jpg"
m.path = "/items/design_box/low1/6.jpg"
m.path = "/items/design_box/low1/7.jpg"
m.path = "/items/design_box/low1/8.jpg"
m.path = "/items/design_box/low1/9.jpg"
m.path = "/items/design_box/low1/10.jpg"
m.save

#LOW 1 : OPTIONS
#NONE

#LOW 2
i = Item.new
i.box = b
i.path = "design_low2"
i.logo_path = "/items/design_box/logo.jpg"
i.original_price = "51300"
i.sale_price = "48500"
i.show_original_price = true
i.quantity = -1
i.limited = false
i.save

#LOW 2 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "Low Price 2"
n.save

#LOW 2 : IMAGES
m = ItemImage.new
m.item = i
m.path = "/items/design_box/low2/1.jpg"
m.path = "/items/design_box/low2/2.jpg"
m.path = "/items/design_box/low2/3.jpg"
m.path = "/items/design_box/low2/4.jpg"
m.path = "/items/design_box/low2/5.jpg"
m.path = "/items/design_box/low2/6.jpg"
m.path = "/items/design_box/low2/7.jpg"
m.save

#LOW 2 :OPTIONS
#NONE

#MIDDLE 1
i = Item.new
i.box = b
i.path = "design_middle1"
i.logo_path = "/items/desgin_box/logo.jpg"
i.original_price = "70800"
i.sale_price = "67500"
i.quantity = -1
i.limited = false
i.save

#MIDDLE 1 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "Middle Price 1"
n.save

#MIDDLE 1 : IMAGES
m = ItemImage.new
m.item = i
m.path = "/items/design_box/middle1/1.jpg"
m.path = "/items/design_box/middle1/2.jpg"
m.path = "/items/design_box/middle1/3.jpg"
m.path = "/items/design_box/middle1/4.jpg"
m.path = "/items/design_box/middle1/5.jpg"
m.path = "/items/design_box/middle1/6.jpg"
m.path = "/items/design_box/middle1/7.jpg"
m.path = "/items/design_box/middle1/8.jpg"
m.path = "/items/design_box/middle1/9.jpg"
m.path = "/items/design_box/middle1/10.jpg"
m.path = "/items/design_box/middle1/11.jpg"
m.save

#MIDDLE 1 : OPTIONS
#NONE

#MIDDLE 2
i = Item.new
i.box = b
i.path = "design_middle2"
i.logo_path = "/items/design_box/logo.jpg"
i.original_price = "70800"
i.sale_price = "67500"
i.quantity = -1
i.limited = false
i.save

#MIDDLE 2 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "Middle Price 2"
n.save

#MIDDLE 2 : IMAGES
m = ItemImage.new
m.item = i
m.path = "/items/design_box/middle2/1.jpg"
m.path = "/items/design_box/middle2/2.jpg"
m.path = "/items/design_box/middle2/3.jpg"
m.path = "/items/design_box/middle2/4.jpg"
m.path = "/items/design_box/middle2/5.jpg"
m.path = "/items/design_box/middle2/6.jpg"
m.path = "/items/design_box/middle2/7.jpg"
m.path = "/items/design_box/middle2/8.jpg"
m.path = "/items/design_box/middle2/9.jpg"
m.path = "/items/design_box/middle2/10.jpg"
m.save

#MIDDLE 2 : OPTIONS
#NONE

#HIGH 1
i = Item.new
i.box = b
i.path = "design_high1"
i.logo_path = "/items/design_box/logo.jpg"
i.original_price = "100800"
i.sale_price = "92500"
i.quantity = -1
i.limited = false
i.save

#HIGH 1 : LOCALE NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "High Price 1"
n.save

#HIGH 1 : IMAGES
m = ItemImage.new
m.item = i
m.path = "/items/design_box/high1/1.jpg"
m.path = "/items/design_box/high1/2.jpg"
m.path = "/items/design_box/high1/3.jpg"
m.path = "/items/design_box/high1/4.jpg"
m.path = "/items/design_box/high1/5.jpg"
m.path = "/items/design_box/high1/6.jpg"
m.save

#HIGH 2
i = Item.new
i.box = b
i.path = "design_high2"
i.logo_path = "/items/design_box/logo.jpg"
i.original_price = "111000"
i.sale_price = "98800"
i.quantity = -1
i.limited = false
i.save

#HIGH 2 : LOCAL NAME
n = ItemName.new
n.item = i
n.locale = "ko"
n.name = "High Price 2"
n.save

#HIGH 2 : IMAGES
m = ItemImage.new
m.item = i
m.path = "/items/design_box/high2/1.jpg"
m.path = "/items/design_box/high2/2.jpg"
m.path = "/items/design_box/high2/3.jpg"
m.path = "/items/design_box/high2/4.jpg"
m.path = "/items/design_box/high2/5.jpg"
m.path = "/items/design_box/high2/6.jpg"
m.path = "/items/design_box/high2/7.jpg"
m.path = "/items/design_box/high2/8.jpg"
m.path = "/items/design_box/high2/9.jpg"
m.path = "/items/design_box/high2/10.jpg"
m.save

#HIGH 2 : OPTIONS
#NONE

#KITCHEN BOX
b = Box.where(:path => "kitchen_box").first
