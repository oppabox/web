def beautybox
#BEAUTY BOX
#SET 1 : BASIC INFO
  b = Box.where(:path => "beauty_box").first
  i = Item.new
    i.box = b
    i.path = "set1"
    i.original_price = "52500"
    i.sale_price = "48500"
    i.opened = false
  i.save

#SET 1 : LOCALE NAME
  name = {"ko" => "피부진정 & 보습세트", "en" => "피부진정 & 보습세트", "cn" => "피부진정 & 보습세트", "ja" => "피부진정 & 보습세트"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end
#SET 1 : OPTIONS
#NONE

#SET 2
  i = Item.new
    i.box = b
    i.path = "set2"
    i.original_price = "116000"
    i.sale_price = "79000"
  i.save

#SET 2 : LOCALE NAME
  name = {"ko" => "스킨 브라이트닝 세트", "en" => "스킨 브라이트닝 세트", "cn" => "스킨 브라이트닝 세트", "ja" => "스킨 브라이트닝 세트"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#SET 3
  i = Item.new
    i.box = b
    i.path = "set3"
    i.original_price = "126000"
    i.sale_price = "92500"
    i.opened = false
  i.save

#SET 3 : LOCALE NAME
  name = {"ko" => "뷰티 버라이어티 세트", "en" => "뷰티 버라이어티 세트", "cn" => "뷰티 버라이어티 세트", "ja" => "뷰티 버라이어티 세트"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#SET 3 : OPTIONS
#NONE

#SET 4
  i = Item.new
    i.box = b
    i.path = "set4"
    i.original_price = "157000"
    i.sale_price = "98500"
  i.save

#SET 4 : LOCALE NAME
  name = {"ko" => "월드 베스트 세트", "en" => "월드 베스트 세트", "cn" => "월드 베스트 세트", "ja" => "월드 베스트 세트"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end
end
