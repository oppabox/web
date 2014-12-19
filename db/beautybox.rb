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
  name = {"ko" => "피부진정 & 보습세트", "en" => "Skin suppression & Moisturizing set", "cn" => "Skin suppression & Moisturizing set", "ja" => "Skin suppression & Moisturizing set"}
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
  name = {"ko" => "스킨 브라이트닝 세트", "en" => "Skin brightening set", "cn" => "Skin brightening set", "ja" => "Skin brightening set"}
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
  name = {"ko" => "뷰티 버라이어티 세트", "en" => "Beauty variety set", "cn" => "Beauty variety set", "ja" => "Beauty variety set"}
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
  name = {"ko" => "월드 베스트 세트", "en" => "World best set", "cn" => "World best set", "ja" => "World best set"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end
end
