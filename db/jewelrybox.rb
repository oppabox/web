def jewelrybox

#JEWELRY BOX
#SET 1
  b = Box.where(:path => "jewelry_box").first
  i = Item.new
    i.box = b
    i.path = "cross"
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

#SET 1 : OPTIONS
#원하는 레터링(영문 대문자 이니셜)가능
#각인 : true, false

#SET 2
  b = Box.where(:path => "jewelry_box").first
  i = Item.new
    i.box = b
    i.path = "knot"
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

#SET 2 : OPTIONS
#NONE

#SET 3
  b = Box.where(:path => "jewelry_box").first
  i = Item.new
    i.box = b
    i.path = "ring"
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
end
