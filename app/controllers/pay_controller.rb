class PayController < ApplicationController

  before_action :login_check, only: [:order, :success, :billing]
  before_action :login_check_ajax, only: [:reorder_quantity]

  def callback
    at_result_cd = params[:allat_result_cd]
    at_result_msg = params[:allat_result_msg]
    at_xid = params[:allat_xid]
    at_eci = params[:allat_eci]
    at_cavv = params[:allat_cavv]
    ret = "<script type='text/javascript'>"
    ret += "window.opener.ftn_approval_submit('#{at_result_cd}','#{at_result_msg}','#{$at_xid}','#{at_eci}','#{at_cavv}');"
    ret += "window.close();"
    ret += "</script>"
    render text: ret
  end

  def dollar_billing
    p = Purchase.find(params[:purchase_id])
    p.recipient = params[:allat_recp_nm]
    p.country = params[:country]
    p.postcode = params[:postcode]
    p.phonenumber = params[:phonenumber]
    p.address_1 = params[:allat_recp_addr_1]
    p.address_2 = params[:allat_recp_addr_2]
    p.address_3 = params[:allat_recp_addr_3]
    p.save
    current_user.name = params[:allat_recp_nm]
    current_user.country = params[:country]
    current_user.postcode = params[:postcode]
    current_user.phonenumber = params[:phonenumber]
    current_user.address_1 = params[:allat_recp_addr_1]
    current_user.address_2 = params[:allat_recp_addr_2]
    current_user.address_3 = params[:allat_recp_addr_3]
    current_user.save

    if p.dollar_billing params
      redirect_to "/mypage/list"
    else
      redirect_to "/pay/order"
    end
  end

  def billing
    p = Purchase.find(params[:purchase_id])
    p.recipient = params[:allat_recp_nm]
    p.country = params[:country]
    p.postcode = params[:postcode]
    p.phonenumber = params[:phonenumber]
    p.address_1 = params[:allat_recp_addr_1]
    p.address_2 = params[:allat_recp_addr_2]
    p.address_3 = params[:allat_recp_addr_3]
    p.save
    current_user.name = params[:allat_recp_nm]
    current_user.country = params[:country]
    current_user.postcode = params[:postcode]
    current_user.phonenumber = params[:phonenumber]
    current_user.address_1 = params[:allat_recp_addr_1]
    current_user.address_2 = params[:allat_recp_addr_2]
    current_user.address_3 = params[:allat_recp_addr_3]
    current_user.save

    if p.billing params[:allat_amt], params[:allat_enc_data], params[:allat_test_yn]
      redirect_to "/mypage/list"
    else
      redirect_to "/pay/order"
    end
  end

  def success

  end

  def order
    @orders = current_user.orders
    @baskets = current_user.baskets
    @all_price = 0
    @orders.each do |o|
      @all_price += o.quantity * o.item.sale_price
    end
    items = Array.new
    @orders.each do |o|
      items << o.item
    end
    @product_cds = items.map{|p| p.id}.join("||")
    @product_nms = items.map{|p| p.display_name}.join("||")
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
