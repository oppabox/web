Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

	get "pay/billing"
  get "pay/success"

  get "item/:number", to: "item#view"

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
