class HomeController < ApplicationController
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
    ret = User.check_sign_params params[:email], params[:password]
    if ret[:result]
      unless User.where(:email => params[:email]).first.nil?
        ret[:result] = false
        ret[:message] = t("duplicated_email")
      else

        user = User.create!({:email => params[:email],
                             :password => params[:password],
                             :password_confirmation => params[:password]})
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
    current_user.country = params[:country]
    current_user.phonenumber = params[:phonenumber]
    current_user.postcode = params[:postcode]
    current_user.address = params[:address]

    ret = Hash.new
    ret[:result] = current_user.save

    render :json => ret
  end

  def step3

  end

  def reset_password

  end

  def renew_password

  end

  def api_renew_password
    ret = Hash.new
    if current_user.nil?
      ret[:result] = false
      ret[:message] = t('must_user_login')
    else
      ret = User.check_sign_params(current_user.email,
                                   params[:password],
                                   params[:password_confirmation])
      if ret[:result]
        ret[:result] = current_user.update(:password => params[:password],
                                            :password_confirmation => params[:password_confirm])
        ret[:message] = t('renew_password_success')
      end
    end

    render :json => ret
  end
end
