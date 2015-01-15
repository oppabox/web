class PayController < ApplicationController

  before_action :login_check, only: [:order, :success, :billing, :korean_payment, :nonkorean_payment]
  before_action :login_check_ajax, only: [:reorder_quantity, :check_order_quantity]
  skip_before_action :http_basic_authenticate, only: :usd_status

  def check_order_quantity
    over_quantity_names = Array.new
    current_user.orders.where(deleted: false).each do |o|
      #item check
      item = o.item
      if item.limited and item.quantity < o.quantity
        over_quantity_names << item.display_name
      end

      #option check
      o.order_option_items.each do |x|
        option_item = x.option_item
        if !option_item.nil? and option_item.limited and option_item.quantity < o.quantity
          over_quantity_names << item.display_name
        end
      end
    end
    if over_quantity_names.size > 0 
      #TODO : HTTPS STATUS MAY NOT BE CORRECT
      render :text => "#{t('over_quantity')} \n#{over_quantity_names.join(", ")}", :status => 404
    # elsif current_user.country != "KR"
    #   render :text => "We're sorry. For now, we serve only for Korean customers due to beta test.", :status => 404
    else
      render :nothing => true, :status => 200
    end
  end

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
    purchase_id = params[:purchase_id]
    p = Purchase.find(purchase_id)

    result = p.krw_billing params

    if result[:is_success]
      redirect_to "/pay/success/#{purchase_id}"
    else
      flash[:alert] = result[:msg]
      redirect_to "/pay/error"
    end
  end

  def success
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
    @baskets = current_user.baskets.where(deleted: false)
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

  def generate_ref_num
    purchase = current_user.purchase
    purchase.set_reference_number
    render :json => purchase.save
  end

  def korean_payment
    order
  end

  def nonkorean_payment
    order
    if params[:mobile]
      @pay_url = EXIMBAY_MOBILE_URL
    else
      @pay_url = EXIMBAY_URL
    end
  end

  def reorder_quantity
    o = Order.where(id: params[:order_id]).take

    if o.purchase.user == current_user
      if params[:method].downcase == "plus"
        o.quantity += 1
      else
        o.quantity -= 1
      end
      if o.save
        render :nothing => true, :status => 200
      else
        render :text => t(:something_wrong), :status => 500
      end
    else
      render :text => t(:something_wrong), :status => 500
    end
  end

  def usd_request
    @secretKey = EXIMBAY_SECRET_KEY
    @pay_url = params[:pay_url]
    @mid = params[:mid]
    @ref = params[:ref]
    @purchase_id = params[:purchase_id] # send on param1

    @cur = params[:cur]
    @product = params[:product]
    @buyer = params[:buyer]
    @tel = params[:tel]
    @email = params[:email]
    @amt = params[:amt]

    @dm_shipTo_country = params[:dm_shipTo_country]
    @dm_shipTo_city = params[:dm_shipTo_city]
    @dm_shipTo_state = params[:dm_shipTo_state]
    @dm_shipTo_street1 = params[:dm_shipTo_street1]
    @dm_shipTo_postalCode = params[:dm_shipTo_postalCode]
    @dm_shipTo_phoneNumber = params[:dm_shipTo_phoneNumber]
    @dm_shipTo_firstName = params[:dm_shipTo_firstName]
    @dm_shipTo_lastName = params[:dm_shipTo_lastName]

    @visitorid = params[:visitorid]
    @linkBuf = @secretKey + "?mid=#{@mid}&ref=#{@ref}&cur=#{@cur}&amt=#{@amt}"
    @fgkey = Digest::SHA256.hexdigest(@linkBuf)
  end

  def usd_return
    @secretKey = EXIMBAY_SECRET_KEY
    @mid = EXIMBAY_MID
    @ver = EXIMBAY_VER
    @txntype = params['txntype']
    @ref = params['ref']
    @cur = params['cur']
    @amt = params['amt']
    @shop = params['shop']
    @buyer = params['buyer']
    @tel = params['tel']
    @email = params['email']
    @product = params['product']
    @lang = params['lang']
    @param1 = params['param1']
    @param2 = params['param2']
    @param3 = params['param3']

    @transid = params['transid']
    @rescode = params['rescode']
    @resmsg = params['resmsg']
    @authcode = params['authcode']
    @cardco = params['cardco']
    @resdt = params['resdt']
    @cardholder = params['cardholder']
    @fgkey = params['fgkey']
    @cardno1 = params['cardno1']
    @cardno4 = params['cardno4']
    
    puts "ver:#{@ver}"
    puts "mid:#{@mid}"
    puts "txntype:#{@txntype}"
    puts "ref:#{@ref}"
    puts "cur:#{@cur}"
    puts "amt:#{@amt}"
    puts "shop:#{@shop}"
    puts "buyer:#{@buyer}"
    puts "tel:#{@tel}"
    puts "email:#{@email}"
    puts "product:#{@product}"
    puts "lang:#{@lang}"
    puts "product:#{@product}"
    puts "param1:#{@param1}"
    puts "param2:#{@param2}"
    puts "param3:#{@param3}"
    
    puts "transid:#{@transid}"
    puts "rescode:#{@rescode}"
    puts "resmsg:#{@resmsg}"
    puts "authcode:#{@authcode}"
    puts "cardco:#{@cardco}"
    puts "resdt:#{@resdt}"
    puts "cardholder:#{@cardholder}"
    puts "fgkey:#{@fgkey}"
    puts "cardno1:#{@cardno1}"
    puts "cardno4:#{@cardno4}"
    if @rescode == "0000"
      @linkBuf = @secretKey+ "?mid=" + @mid +"&ref=" + @ref +"&cur=" +@cur +"&amt=" +@amt +"&rescode=" +@rescode +"&transid=" +@transid
      puts "link : "+ @linkBuf
      @newFgkey = Digest::SHA256.hexdigest(@linkBuf)
      puts "fgkey :"+ @fgkey
      puts "newFgkey :"+ @newFgkey
      if @fgkey.downcase != @newFgkey
        @rescode = "ERROR"
        @resmsg = "Invalid transaction"
      end
    else
      flash[:alert] = @resmsg
    end
  end

  def usd_status
    @secretKey = EXIMBAY_SECRET_KEY

    @ver = params['ver']
    @mid = params['mid']
    @txntype = params['txntype']
    @ref = params['ref']
    @cur = params['cur']
    @amt = params['amt']
    @shop = params['shop']
    @buyer = params['buyer']
    @tel = params['tel']
    @email = params['email']
    @product = params['product']
    @lang = params['lang']
    @param1 = params['param1']
    @param2 = params['param2']
    @param3 = params['param3']

    @transid = params['transid']
    @rescode = params['rescode']
    @resmsg = params['resmsg']
    @authcode = params['authcode']
    @cardco = params['cardco']
    @resdt = params['resdt']
    @cardholder = params['cardholder']
    @fgkey = params['fgkey']
    @cardno1 = params['cardno1']
    @cardno4 = params['cardno4']

    p = Purchase.find(@param1)

    if (@rescode == "0000")
      @linkBuf = @secretKey + "?mid=" + @mid +"&ref=" + @ref + "&cur=" + @cur +"&amt=" + @amt +"&rescode=" + @rescode + "&transid=" +@transid
      @newFgkey = Digest::SHA256.hexdigest(@linkBuf)
      if (@fgkey.downcase != @newFgkey)
        @rescode = "ERROR"
        @resmsg = "Invalid transaction"
      end
    end

    if (@rescode == "0000")
      p.status = PURCHASE_PAID
      p.order_no = "authcode: #{@authcode}"
      p.approval_ymdhms = @resdt
      p.amt = @amt + @cur
      p.seq_no = "transid: #{@transid}"
      p.pay_type = "CARD #{@cardco} #{@cardno1}********#{@cardno4} by: #{@cardholder}"
      #apply your database or file system.
    end
    p.replycd = @rescode
    p.replymsg = @resmsg
    # reference number
    p.set_reference_number
    # pay option
    p.pay_option = PAY_OPTIONS["CARD"]
    render text: p.save
  end
end
