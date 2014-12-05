def starbox
#STAR BOX
  b = Box.where(:path => "star_box").first

#김재중박스
  i = Item.new
    i.box = b
    i.path = "jj"
    i.logo_path = "/images/items/star_box/jj/jj.jpg"
    i.original_price = "227000"
    i.sale_price = "58000"
    i.quantity = -1
    i.limited = true
  i.save

#김재중박스 : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "김재중"
  n.save

#김재중박스 : IMAGES
  1.upto(2) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/star_box/jj/#{x}.jpg"
    m.save
  end

#이민호박스
  i = Item.new
    i.box = b
    i.path = "minho"
    i.logo_path = "/images/items/star_box/minho/minho.jpg"
    i.original_price = "71500"  #EXO BACK : 19,500
                                #SNAP BACK : 32,500
                                #PHOTO BOOK : 19,530          전부 표기 해주세요.
    i.sale_price = "53000"
    i.quantity = -1
    i.limited = true
  i.save

#이민호박스 : LOCALE NAME
  n = ItemName.new
  n.item = i
  n.locale = "ko"
  n.name = "이민호"
  n.save

#이민호박스 : IMAGES
  1.upto(4) do |x|
    m = ItemImage.new
    m.item = i
    m.path = "/images/items/star_box/minho/#{x}.jpg"
    m.save
  end
end
