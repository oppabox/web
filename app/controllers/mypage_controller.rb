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

  def recalculate
    order = Order.find(params[:order_id])
    quantity = params[:amount].to_i
    price = order.total_price
    shipping_fee = order.get_delivery_fee(quantity) == 0 ? 2700 : order.get_delivery_fee(quantity)
    diff_quantity = order.quantity - quantity
    diff_shipping_fee = diff_quantity == 0 ? 0 : order.get_delivery_fee(diff_quantity)
    # 총 결제비에서 diff quantity 만큼 구매했다고 생각하고 차액계산
    cancel_amount = (order.final_order_price - (diff_quantity * price + diff_shipping_fee))
    # 왕복 택배비
    shipping = Order.change_currency(shipping_fee * 2)
    # 총 결제비에서 diff quantity 만큼의 물건 비용을 제한 후 취소한 만큼의 취소량의 왕복 택배비를 뺀 금액
    actual_amount = Order.change_currency(cancel_amount - shipping_fee * 2)
    render :json => {'cancel_amount' => Order.change_currency(cancel_amount), 'shipping' => shipping, 'actual_amount' => actual_amount}
  end

  def recalculate_cancel
    order = Order.find(params[:order_id])
    diff_quantity = order.quantity - params[:amount].to_i
    diff_shipping_fee = diff_quantity == 0 ? 0 : order.get_delivery_fee(diff_quantity)

    # diff quantity만큼 구매한 것과 동일, 따라서 차액을 환불
    rtn = Order.change_currency( order.final_order_price - (order.total_price * diff_quantity + diff_shipping_fee) )
    puts rtn
    render :text => rtn
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
