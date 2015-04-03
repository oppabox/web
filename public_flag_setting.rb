# BLOG STORE 입점 박스로 변경
# public_flag : true -> 입점 방식 ( 일반 어드민 유저에서 true된 폴더에 박스 설립 가능 , false -> 일반 어드민 유저에서 박스 설립 불가능
# default : false
box = Box.where(display_name: "BLOG STORE").take
box.public_flag = true
box.save
