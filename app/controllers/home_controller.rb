class HomeController < ApplicationController
  before_action :login_check,       only: [:step3] 
  before_action :login_check_ajax,  only: [:api_step3]

  def index
    @boxes = Box.all
  end

  def join

  end

  def login

  end

  def api_login
    ret = User.check_sign_params params[:email], params[:password]

    if ret[:result]
      user = User.where(:email => params[:email]).first
      if !user.nil? and user.valid_password?(params[:password])
        sign_in(:user, user)
        ret[:result] = true
      else
        ret[:result] = false
        ret[:message] = t("cannot_signin")
      end
    end

    render :json => ret
  end

  def step1

  end
  
  def step2

  end
   
  def api_step2
    ret = User.check_sign_params params[:email], params[:password], params[:password_confirm]
    if ret[:result]
      unless User.where(:email => params[:email]).first.nil?
        ret[:result] = false
        ret[:message] = t("duplicated_email")
      else

        user = User.create!({:email => params[:email],
                             :password => params[:password],
                             :country => params[:country],
                             :password_confirmation => params[:password_confirm]})
        if user == false
          ret[:result] = false
          ret[:message] = t("cannot_signup")
        else
          sign_in(user)
          ret[:result] = true
        end
      end
    end

    render :json => ret
  end

  def api_step3
    current_user.option_flag = true
    current_user.name = params[:name]
    current_user.phonenumber = params[:phonenumber]
    current_user.postcode = params[:postcode]
    current_user.address = params[:address]
    current_user.city = params[:city]
    current_user.state = params[:state]

    address_array = params[:address].split(" ")
    address_split = Array.new(3){""}

    address_array.each do |x|
      0.upto(address_split.size - 1) do |y|
        next if (address_split[y] + x).size > 33 #UPS can have address with legnth 33.
        address_split[y] += " " if address_split[y].size > 1
        address_split[y] += x
        break
      end
    end

    ret = Hash.new
    ret[:result] = current_user.save

    render :json => ret
  end

  def step3

  end

  def welcome

  end

  def reset_password
  end

  def api_reset_password
    ret = Hash.new
    ret = User.check_sign_params(params[:email])
    if ret[:result]
      user = User.where(:email => params[:email]).first
      if user.nil?
        ret[:result] = false
        ret[:message] = t('reset_password_no_email')
      else
        ret[:result] = true
        ret[:message] = t('reset_password_success')
        user.send_password_reset
      end
    end
    render :json => ret
  end

  def renew_password
    @user = User.where(:reset_password_token => session[:reset_password_token]).first

    session[:reset_password_token] = params[:reset_password_token]
  end

  def api_renew_password
    ret = Hash.new
    if session[:reset_password_token].nil?
      ret[:result] = false
      ret[:message] = t('must_user_login')
    else
      user = User.where(:reset_password_token => session[:reset_password_token]).first
      ret = User.check_sign_params(user.email,
                                   params[:password],
                                   params[:password_confirmation])

      if ret[:result]
        ret[:result] = user.update(:password => params[:password],
                                   :password_confirmation => params[:password_confirm])
        ret[:message] = t('renew_password_success')
      end
    end

    render :json => ret
  end

  def terms
  end

  def privacy
  end
end
