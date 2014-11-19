class ItemController < ApplicationController
  before_action :login_check_ajax,  only: [:add_to_basket, :del_from_basket, :add_to_order, :del_from_order]

  def view
    @item = Item.where(:path => params[:name]).first
  end

  def add_to_basket
    i = Basket.where(item_id: params[:item_id]).take
    if i.nil?
      i = Basket.new(user_id: current_user.id,
                     item_id: params[:item_id])
      if i.save
        render :nothing => true, :status => 200
      else
        render :text => t(:something_wrong), :status => 500
      end
    else
      render :text => "이미 장바구니에 담겨있습니다", :status => 200
    end
  end

  def del_from_basket
    b = Basket.where(user_id: current_user.id,
                     item_id: params[:item_id]).take
    if b.delete
      render :nothing => true, :status => 200
    else
      render :text => t(:something_wrong), :status => 500
    end
  end

  def del_from_order
    b = current_user.orders.where(item_id: params[:item_id]).take
    if b.delete
      render :nothing => true, :status => 200
    else
      render :text => t(:something_wrong), :status => 500
    end
  end

  def add_to_order
    p = current_user.purchase
    if p.nil?
      p = Purchase.create(user_id: current_user.id,
                          recipient: current_user.name,
                          country: current_user.country,
                          address_1: current_user.address_1,
                          address_2: current_user.address_2,
                          address_3: current_user.address_3,
                          postcode: current_user.postcode,
                          phonenumber: current_user.phonenumber,
                          status: "ordering")
    end
    o = Order.where(purchase_id: p.id, item_id: params[:item_id]).take
    if o.nil?
      o = Order.new
      o.purchase_id = p.id
      o.item_id = params[:item_id]
      o.quantity = params[:quantity]
    else
      o.quantity = o.quantity + 1
    end
    if o.save
      render :nothing => true, :status => 200
    else
      render :text => t(:something_wrong), :status => 500
    end
  end
end
