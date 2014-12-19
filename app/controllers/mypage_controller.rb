class MypageController < ApplicationController

  before_action :login_check, only: [:info, :basket, :list, :carry, :reset_password]
  before_action :login_check_ajax, only: [:api_info, :api_reset_password]

  def info
  end

  def basket
    @baskets = current_user.baskets
  end

  def api_info
    current_user.phonenumber = params[:phonenumber]
    current_user.postcode = params[:postcode]
    current_user.address = params[:address]
    ret = current_user.save

    render :json => ret
  end

  def list
  end

  def carry
  end

  def reset_password
  end

  def api_reset_password
    ret = Hash.new
    if current_user.valid_password?(params[:current_password])
      if current_user.nil?
        ret[:result] = false
        ret[:message] = t('must_user_login')
      else
        ret = User.check_sign_params(current_user.email,
                                     params[:password],
                                     params[:password_confirm])

        if ret[:result]
          user = current_user
          user.password = params[:password]
          user.password_confirmation = params[:password_confirm]
          ret[:result] =  user.save
          ret[:message] = t('renew_password_success')

          sign_out()
          sign_in(:user, user)
        end
      end
    else
      ret[:result] = false
      ret[:message] = t('current_password_invalid')
    end
    render :json => ret
  end

  def edit_address
    current_user.name = params[:userrealname]
    current_user.phonenumber = params[:phonenumber]
    current_user.postcode = params[:postcode]
    current_user.address = params[:address]
    current_user.city = params[:city]
    current_user.state = params[:state]
    
		if current_user.save		
			flash[:alert] = "Edit Success!"
    	redirect_to :back
		else
			flash[:alert] = "Edit Fail"
			redirect_to :back
		end
  end
end
