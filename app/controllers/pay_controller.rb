class PayController < ApplicationController

  before_action :login_check, only: [:order, :success, :billing]
  before_action :login_check_ajax, only: [:reorder_quantity]

  def callback
    at_result_cd = params[:allat_result_cd]
    at_result_msg = params[:allat_result_msg]
    at_xid = params[:allat_xid]
    at_eci = params[:allat_eci]
    at_cavv = params[:allat_cavv]
    logger.debug "====\n" + at_result_msg.encoding.name
    ret = "<script type='text/javascript'>"
    ret += "window.opener.ftn_approval_submit('#{at_result_cd}','#{at_result_msg}','#{$at_xid}','#{at_eci}','#{at_cavv}');"
    ret += "window.close();"
    ret += "</script>"
    render text: ret
  end

  def billing
    p = Purchase.find(params[:purchase_id])

    address = params[:address]
    postcode = params[:postcode]
    purchase_id = params[:purchase_id]

    if p.krw_billing params
      redirect_to controller: 'pay',
                  action: 'success',
                  purchase_id: purchase_id,
                  address: address,
                  postcode: postcode
    else
      redirect_to "/pay/error"
    end
  end

  def success
    @address = params[:address]
    @postcode = params[:postcode]
    @purchase = current_user.purchased_find params[:purchase_id]
    unless @purchase
      redirect_to '/'
    end
  end

  def change_currency
    render :text => Order.change_currency(params[:total_price].to_i)
  end

  def order
    purchase = current_user.purchase
      purchase.address = current_user.address
      purchase.city = current_user.city
      purchase.postcode = current_user.postcode
      purchase.phonenumber = current_user.phonenumber
      purchase.recipient = current_user.name
      purchase.state = current_user.state
    purchase.save

    @orders = current_user.orders
    @baskets = current_user.baskets
    @all_price = 0
    @orders.each do |o|
      @all_price += o.quantity * o.total_price
    end
    items = Array.new
    @orders.each do |o|
      items << o.item
    end
    @product_cds = items.map{|p| p.id}.join("||")
    @product_nms = items.map{|p| p.display_name}.join("||")
    @delivery_fee = purchase.get_delivery_fee
  end

  def korean_payment
    order
  end

  def nonkorean_payment
    order
  end

  def reorder_quantity
    o = Order.where(id: params[:order_id]).take
    if params[:method].downcase == "plus"
      o.quantity += 1
    else
      o.quantity -= 1
    end
    o.quantity = 1 if o.quantity < 1

    if o.save
      render :nothing => true, :status => 200
    else
      render :text => t(:something_wrong), :status => 500
    end
  end
end
