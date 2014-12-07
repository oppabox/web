def starbox
  b = Box.where(:path => "star_box").first

#김재중박스
  i = Item.new
    i.box = b
    i.path = "jaejoong"
    i.original_price = "227000"
    i.sale_price = "58000"
    i.quantity = -1
    i.limited = true
  i.save

#김재중박스 : LOCALE NAME
  name = {"ko" => "김재중박스", "en" => "JaeJoong Box", "cn" => "김재중박스", "ja" => "김재중박스"}
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
    i.original_price = "71500"  #EXO BACK : 19,500
                                #SNAP BACK : 32,500
                                #PHOTO BOOK : 19,530          전부 표기 해주세요.
    i.sale_price = "53000"
    i.quantity = -1
    i.limited = true
  i.save

#이민호박스 : LOCALE NAME
  name = {"ko" => "이민호박스", "en" => "Minho Box", "cn" => "이민호박스", "ja" => "이민호박스"}
  name.each do |x, y|
    n = ItemName.new
    n.item = i
    n.locale = x
    n.name = y
    n.save
  end
end
