class PayController < ApplicationController
  def billing

  end

  def success

  end

  def order
    @orders = Order.where(:user_id => current_user.id)

  end

  def submit_item

    if !user_signed_in?
      render :nothing => true, :status => 401
    else
      o = Order.new
      o.item_id = params[:item_id]
      o.user = current_user
      o.postcode = current_user.postcode
      o.country = current_user.country
      o.phonenumber = current_user.phonenumber
      o.address_1 = current_user.address_1
      o.address_2 = current_user.address_2
      o.address_3 = current_user.address_3

      if o.save
        render :nothing => true, :status => 200
      else
        render :text => t(:something_wrong), :status => 500
      end
    end

  end
end
