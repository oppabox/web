class ItemController < ApplicationController
  before_action :login_check_ajax,  only: [:add_to_basket, :del_from_basket, :add_to_order, :del_from_order]
  before_action :input_option_validation, only: [:add_to_order]

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
    i = Basket.where(user_id: current_user.id, item_id: params[:item_id]).take
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
    b.deleted = true
    if b.save
      render :nothing => true, :status => 200
    else
      render :text => t(:something_wrong), :status => 500
    end
  end

  def del_from_order
    o = current_user.orders.where(item_id: params[:item_id]).take
    o.status = Order::STATUS_DELETED
    if o.save
      render :nothing => true, :status => 200
    else
      render :text => t(:something_wrong), :status => 500
    end
  end

  def add_to_order
    p = current_user.purchase
    if p.nil?
      p = Purchase.create(user_id: current_user.id, status: Purchase::STATUS_ORDERING)
    end
    # state of p is always STATUS_ORDERING
    # which means that orders' state are either STATUS_ORDERING or STATUS_DELETED

    new_order_is_needed = true
    # try to find exist orders whose state is STATUS_ORDERING
    orders = Order.valid.where(order_periodic: params[:periodic], 
                          purchase_id: p.id, 
                          item_id: params[:item_id])
    o = Order.new

    if !orders.empty?
      orders.each do |oo|
        temp_new_order_is_needed = false
        oo.order_option_items.each do |x|
          current_option = x.option
          if current_option.option_type == 1
            temp_new_order_is_needed = true if (params[:option_items]["#{x.option_id}"].to_s != x.option_item_id.to_s)
          else
            temp_new_order_is_needed = true if (params[:option_items]["#{x.option_id}"].to_s != x.option_text.to_s)
          end
        end
        if temp_new_order_is_needed == false
          new_order_is_needed = false
          o = oo
          break
        end
      end
    end

    if new_order_is_needed
      o.purchase_id = p.id
      o.item_id = params[:item_id]
      o.quantity = params[:quantity]
      o.order_periodic = params[:periodic].to_i
      shipping_id = params[:shipping].to_i
      if shipping_id.nil?
        o.shipping = User.current.country == "KR" ? o.item.shippings.domestic.take : o.item.shippings.foreign.take
      else
        o.shipping = Shipping.find(shipping_id)
      end
      o.save

      #options
      (params[:option_items]||Array.new).each do |x, y|
        ooi = OrderOptionItem.new
        option = Option.where(:id => x).take
        if option.option_type == 1
          ooi.option_item_id = y
        else 
          ooi.option_text = y
        end
        ooi.order = o
        ooi.option = option
        ooi.save
      end
    else
      o.quantity = o.quantity + params[:quantity].to_i
      o.order_periodic = params[:periodic].to_i
      o.save
    end

    render :nothing => true, :status => 200
  end
end
