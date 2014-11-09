Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

	get "pay/billing"
  get "pay/success"
	
	#상품 테스트
  #get "item/:number", to: "item#view"
	get "item/view"
	get "item/skinrx_set1"
	get "item/skinrx_set2"
	get "item/skinrx_set3"
	get "item/skinrx_set4"

  #home
  get "home/main"
  get "home/step1"
  get "home/step2"
  get "home/step3"
  get "home/login"

  #box
  get "box/:name", to: "box#index"

  get "home/reset_password"
  get "home/renew_password"

  post "home/api_step2"
  post "home/api_step3"
  post "home/api_login"

  get "mypage/" => "mypage#list"
  get "mypage/list"
  get "mypage/carry"
end
