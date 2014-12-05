def beautybox
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
#ko
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/beauty_box/set1/1.jpg"
  m.save
# #en
# 1.upto(2) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set1/en/#{x}.jpg"
#   m.save
# end
# #ja
# 1.upto(2) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set1/ja/#{x}.jpg"
#   m.save
# end
# #zh
# 1.upto(2) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set1/zh/#{x}.jpg"
#   m.save
# end

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
#ko
  m = ItemImage.new
  m.item = i
  m.path = "/images/items/beauty_box/set2/1.jpg"
  m.save
# #en
# 1.upto(2) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set2/en/#{x}.jpg"
#   m.save
# end
# #ja
# 1.upto(2) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set2/ja/#{x}.jpg"
#   m.save
# end
# #zh
# 1.upto(2) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set2/zh/#{x}.jpg"
#   m.save
# end
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
# #en
# 1.upto(5) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set3/en/#{x}.jpg"
#   m.save
# end
# #ja
# 1.upto(5) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set3/ja/#{x}.jpg"
#   m.save
# end
# #zh
# 1.upto(5) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set3/zh/#{x}.jpg"
#   m.save
# end

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
# #en
# 1.upto(2) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set4/en/#{x}.jpg"
#   m.save
# end
# #ja
# 1.upto(2) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set4/ja/#{x}.jpg"
#   m.save
# end
# #zh
# 1.upto(2) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/beauty_box/set4/zh/#{x}.jpg"
#   m.save
# end
end
