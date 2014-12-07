def beautybox
#BEAUTY BOX
#SET 1 : BASIC INFO
  b = Box.where(:path => "beauty_box").first
  i = Item.new
    i.box = b
    i.path = "set1"
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

#SET 1 : OPTIONS
#NONE

#SET 2
  i = Item.new
    i.box = b
    i.path = "set2"
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

#SET 3
  i = Item.new
    i.box = b
    i.path = "set3"
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

#SET 3 : OPTIONS
#NONE

#SET 4
  i = Item.new
    i.box = b
    i.path = "set4"
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
end
