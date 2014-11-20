class PayController < ApplicationController

  before_action :login_check, only: [:order, :success, :billing]
  before_action :login_check_ajax, only: [:reorder_quantity]

  def billing
    p = Purchase.find(params[:purchase_id])
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
