class ItemController < ApplicationController
  before_action :login_check_ajax,  only: [:add_to_basket, :del_from_basket, :add_to_order, :del_from_order]

  def view
    @item = Item.where(:path => params[:name]).first
    @item_image_files = Array.new
    index = 1
    begin
      exists = File.exists?(Rails.root.join("public", "images", "items", @item.box.path, @item.path, I18n.locale.to_s, "#{index}.jpg").to_s)
      @item_image_files << index if exists 
      index += 1
    end while exists 

    if @item.opened != true
      render :nothing => true, :status => 401
    end


  end

  def add_to_basket
    i = Basket.where(item_id: params[:item_id]).take
    if i.nil?
      i = Basket.new(user_id: current_user.id,
                     item_id: params[:item_id])
      if i.save
        render :text => t(:basket_add_success), :status => 200
      else
        render :text => t(:something_wrong), :status => 500
      end
    else
      render :text => t(:basket_already_add), :status => 200
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
                          address: current_user.address,
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
      o.order_periodic = params[:periodic]
    else
      o.quantity = o.quantity + params[:quantity]
      o.order_periodic = params[:periodic]
    end

    #options
    error_flag = false
    params[:option_items].each do |x, y|
      ooi = OrderOptionItem.new
      option = Option.where(:id => x).take
      if option.option_type == 1
        option_item = OptionItem.where(:id => y).take
        ooi.option_item = option_item
      else 
        ooi.option_text = y
      end
      ooi.order = o
      ooi.option = option
      if !ooi.save
        error_flag = true
      end
    end
    if !error_flag and o.save
      render :nothing => true, :status => 200
    else
      render :text => t(:something_wrong), :status => 500
    end
  end
end
