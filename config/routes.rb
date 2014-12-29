Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root 'home#index'

	post "pay/billing"
	post "pay/dollar_billing"
  post "pay/callback"

  get "pay/success/:purchase_id" => "pay#success"
  post "pay/success/:purchase_id" => "pay#success"
  get "pay/error"
  get "pay/order"
  get "pay/check_order_quantity"
  get "pay/korean_payment"
  get "pay/nonkorean_payment"

	post "pay/reorder_quantity"
  post "pay/change_currency"

  # Nonkorean payment
  post "pay/usd_request"
  post "pay/usd_return"
  post "pay/usd_status"
  post "pay/usd_finish"

  post "item/add_to_basket"
  post "item/add_to_order"
  post "item/del_from_basket"
  post "item/del_from_order"
	
  get "item/:name", to: "item#view"

  #home
  get "terms"     , to: "home#terms"
  get "privacy"   , to: "home#privacy"
  get "home/main"
  get "home/step1"
  get "home/nationality"
  get "home/step2"
  get "home/step3"
  get "home/signup_choice"
  get "home/add_email"
  get "home/welcome"
  get "home/login"
	
  #box
  get "box/:name", to: "box#index"

  get "home/reset_password"
  get "home/renew_password(/:reset_password_token)" => "home#renew_password", as: :renew_password

  post "home/api_step2"
  post "home/api_step3"
  post "home/api_login"
  post "home/api_add_email"
  post "home/api_renew_password"
  post "home/api_reset_password"
  post "home/api_nationality"

  get "mypage/" => "mypage#list"
  get "mypage/basket"
  get "mypage/info"
  post "mypage/api_info"
  get "mypage/list"
  get "mypage/carry"
  get "mypage/reset_password"
  post "mypage/api_reset_password"
  get "mypage/api_info"
  post "mypage/edit_address"
end
