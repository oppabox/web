Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  root 'home#index'

	post "pay/billing"
  post "pay/success"

  #테스트용
  get "pay/success"
  get "pay/order"

  post "pay/submit_item"
	
	#상품 테스트
  get "item/:name", to: "item#view"

  #home
  get "home/main"
  get "home/step1"
  get "home/step2"
  get "home/step3"
  get "home/login"

  #box
  get "box/:name", to: "box#index"

  get "home/reset_password"
  get "home/renew_password(/:reset_password_token)" => "home#renew_password", as: :renew_password

  post "home/api_step2"
  post "home/api_step3"
  post "home/api_login"
  post "home/api_renew_password"
  post "home/api_reset_password"

  get "mypage/" => "mypage#info"
  get "mypage/info"
  post "mypage/api_info"
  get "mypage/list"
  get "mypage/carry"
  get "mypage/api_info"
end
