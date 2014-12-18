def jewelrybox

#JEWELRY BOX
#SET 1
  b = Box.where(:path => "jewelry_box").first
  i = Item.new
    i.box = b
    i.path = "knot"
    i.original_price = "113000"
    i.sale_price = "49000"
  i.save

#SET 1 : LOCALE NAME
  name = {"ko" => "925 Silver knot set", "en" => "925 Silver knot set", "cn" => "925 Silver knot set", "ja" => "925 Silver knot set"}
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
  b = Box.where(:path => "jewelry_box").first
  i = Item.new
    i.box = b
    i.path = "cross"
    i.original_price = "250000"
    i.sale_price = "89000"
  i.save

#SET 2 : LOCALE NAME
  name = {"ko" => "925 Silver Cross Initial Bracelet", "en" => "925 Silver Cross Initial Bracelet", "cn" => "925 Silver Cross Initial Bracelet", "ja" => "925 Silver Cross Initial Bracelet"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#SET 2 : OPTIONS
#원하는 레터링(영문 대문자 이니셜)가능
  o = Option.new
    o.title = "Length"
    o.option_type = 1
    o.item = i
  o.save

  {"13cm" => "0", "15cm" => "0", "17.5cm" => "0"}.each do |x, y|
    oi = OptionItem.new
      oi.option = o
      oi.name = x
      oi.price_change = y
    oi.save
  end

#각인 : true, false
  o = Option.new
  o.title = "Lettering"
  o.option_type = 2
  o.item = i
  o.save

#SET 3
  b = Box.where(:path => "jewelry_box").first
  i = Item.new
    i.box = b
    i.path = "ring"
    i.original_price = "69000"
    i.sale_price = "49000"
  i.save

#SET 3 : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "Cubic brass ring"
  n.save
  name = {"ko" => "Cubic Brass Ring", "en" => "Cubic Brass Ring", "cn" => "Cubic Brass Ring", "ja" => "Cubic Brass Ring"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end
end
