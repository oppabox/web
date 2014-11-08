Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

	get "pay/billing"
  get "pay/success"

  get "item/:number", to: "item#view"

  get "home/main"
  get "home/step1"
  get "home/step2"
  get "home/step3"
  get "home/login"

  get "mypage/" => "mypage#list"
  get "mypage/list"
  get "mypage/carry"
end
