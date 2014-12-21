def starbox
  b = Box.where(:path => "star_box").first

#김재중박스
  i = Item.new
    i.box = b
    i.path = "jaejoong"
    i.original_price = "227000"
    i.sale_price = "58000"
    i.quantity = 300
    i.limited = true
    i.periodic = true #주기 (1개월, 3개월, 6개월, 12개월)
    i.opened = true
    i.buy_limit = 5
  i.save

#김재중박스 : LOCALE NAME
  name = {"ko" => "김재중박스", "en" => "Kim JaeJoong Box", "cn" => "Kim JaeJoong Box", "ja" => "Kim JaeJoong Box"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end

#이민호박스
  i = Item.new
    i.box = b
    i.path = "minho"
    i.original_price = "71500"
    i.sale_price = "53000"
    i.quantity = 300 
    i.limited = true
    i.opened = false
    i.buy_limit = 5
  i.save

#이민호박스 : LOCALE NAME
  name = {"ko" => "이민호박스", "en" => "Lee Minho Box", "cn" => "Lee Minho Box", "ja" => "Lee Minho Box"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end
end
