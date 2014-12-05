def jewelrybox

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
#ko
  1.upto(3) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/jewelry_box/cross/#{x}.jpg"
    m.save
  end
# #en
# 1.upto(3) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/jewelry_box/cross/en/#{x}.jpg"
#   m.save
# end
# #ja
# 1.upto(3) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/jewelry_box/cross/ja/#{x}.jpg"
#   m.save
# end
# #zh
# 1.upto(3) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/jewelry_box/cross/zh/#{x}.jpg"
#   m.save
# end

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
#ko
  1.upto(3) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/jewelry_box/knot/#{x}.jpg"
    m.save
  end
# #en
# 1.upto(3) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/jewelry_box/knot/en/#{x}.jpg"
#   m.save
# end
# #ja
# 1.upto(3) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/jewelry_box/knot/ja/#{x}.jpg"
#   m.save
# end
# #zh
# 1.upto(3) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/jewelry_box/knot/zh/#{x}.jpg"
#   m.save
# end

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
#ko
  1.upto(3) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/jewelry_box/ring/#{x}.jpg"
    m.save
  end
# #en
# 1.upto(3) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/jewelry_box/ring/en/#{x}.jpg"
#   m.save
# end
# #ja
# 1.upto(3) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/jewelry_box/ring/ja/#{x}.jpg"
#   m.save
# end
# #zh
# 1.upto(3) do |x|
#   m = ItemImage.new
#   m.item = i
#   m.path = "/images/items/jewelry_box/ring/zh/#{x}.jpg"
#   m.save
# end

#SET 3 : OPTIONS
#사이즈 옵션표 확인 후 추가
end
