Rails.application.routes.draw do
  root 'home#index'
	get "pay/billing"
  post "pay/success"
  get "item/:number", to: "item#view"
  get "home/main"
  get "home/join"
  get "home/login"
  get "mypage/" => "mypage#list"
  get "mypage/list"
  get "mypage/carry"
end
