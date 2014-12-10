class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def all
      auth = request.env["omniauth.auth"]
      user = User.where(provider: auth.provider, uid: auth.uid).first

      if user.nil?
        session[:auth] = auth
        if session[:aggreement]
          redirect_to "/home/add_email"
        else
          redirect_to "/home/step1"
        end
      else
        sign_in_and_redirect user, notice: 'Success'
      end
    end

    alias_method :facebook, :all
    alias_method :twitter, :all

  # alias_method :weibo, :all
  # def facebook
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   @user = User.from_omniauth(request.env["omniauth.auth"])

  #   if @user.persisted?
  #     sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  # def weibo
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   @user = User.from_omniauth(request.env["omniauth.auth"])

  #   if @user.persisted?
  #     sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Weibo") if is_navigational_format?
  #   else
  #     session["devise.weibo_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

end
