class MypageController < ApplicationController
  def info

  end

  def api_info
    current_user.country = params[:country]
    current_user.phonenumber = params[:phonenumber]
    current_user.postcode = params[:postcode]
    current_user.address_1 = params[:address_1]
    current_user.address_2 = params[:address_2]
    current_user.address_3 = params[:address_3]
    ret = current_user.save

    render :json => ret
  end

  def list
  end

  def carry
  end
end
