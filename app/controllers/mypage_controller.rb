class MypageController < ApplicationController

  before_action :login_check, only: [:info, :basket, :list, :carry, :reset_password]
  before_action :login_check_ajax, only: [:api_info, :api_reset_password]

  def info
  end

  def basket
    @baskets = current_user.baskets.valid
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

  def new_request
    @order = Order.find(params[:order_id])

    periodic = if @order.item.periodic then "(" + t("periodoc_#{@order.order_periodic}month") + ")" else nil end
    @options = Array.new(1){periodic}
    @order.order_option_items.each do |x|
     @options << x.option_item.name if  x.option.option_type == 1
     @options << x.option_text if  x.option.option_type == 2
    end
    @options.compact!
  end

  def change_currency
    shipping_fee = 5400
    cancel_amount = Order.change_currency(params[:amount])
    shipping = Order.change_currency(shipping_fee)
    actual_amount = Order.change_currency(params[:amount].to_i - shipping_fee)
    render :json => {'cancel_amount' => cancel_amount, 'shipping' => shipping, 'actual_amount' => actual_amount}
  end

  def return_request
    rtn = Return.new
    rtn.order_id = params['order_id']
    rtn.quantity = params['quantity']
    rtn.reason = params['reason']
    rtn.reason_details = params['reason_detail']
    rtn.sender = params['sender']
    rtn.phonenumber = params['phonenumber']
    rtn.postcode = params['postcode']
    rtn.address = params['address']
    rtn.city = params['city']
    rtn.country = params['country']
    rtn.state = params['state']
    
    data = {}
    if rtn.save
      data['result'] = true
      data['message'] = "Return form is successfully requested!"
    else
      data['result'] = true
      data['message'] = "Return form has some problems!"
    end

    render :json => data
  end

  def cancel_request
    cancel = Cancel.new
    cancel.quantity = params['quantity']
    cancel.reason =  params['reason']
    cancel.reason_details =  params['reason_detail']
    cancel.order_id = params['order_id']

    data = {}
    if cancel.save
      data['result'] = true
      data['message'] = "Cancel form is successfully requested!"
    else
      data['result'] = false
      data['message'] = "Cancel form has some problems!"
    end

    render :json => data
  end

  def change_request
    change = Change.new
    change.order_id = params['order_id']
    change.quantity = params['quantity']
    change.reason = params['reason']
    change.reason_details = params['reason_detail']
    change.sender = params['sender']
    change.phonenumber = params['phonenumber']
    change.postcode = params['postcode']
    change.address = params['address']
    change.city = params['city']
    change.country = params['country']
    change.state = params['state']
    
    data = {}
    if change.save
      data['result'] = true
      data['message'] = "Return form is successfully requested!"
    else
      data['result'] = false
      data['message'] = "Return form has some problems!"
    end

    render :json => data
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
			flash[:alert] = t('modify_address_complete')
		else
			flash[:alert] = t('modify_address_error')
		end
    redirect_to :back
  end
end
