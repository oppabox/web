class PayController < ApplicationController
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
      logger.debug o.item.inspect
    end
    @product_cds = items.map{|p| p.id}.join("||")
    @product_nms = items.map{|p| p.display_name}.join("||")
  end

  def fix_to_order
    o = Order.where(item_id: params[:item_id]).take
    
    o.quantity = params[:quantity]

    if o.save
      render :nothing => true, :status => 200
    else
      render :text => t(:something_wrong), :status => 500
    end
  end
end

#  // 올앳 결제 서버와 통신 : ApprovalReq->통신함수, $at_txt->결과값
#  //----------------------------------------------------------------
#  // (올앳 결제 서버와 통신 후에 로그를 남기면, 통신에러시 빠른 원인파악이 가능합니다.)
#    [신용카드 전표출력 예제]
#
#    결제가 정상적으로 완료되면 아래의 소스를 이용하여, 고객에게 신용카드 전표를 보여줄 수 있습니다.
#    전표 출력시 상점아이디와 주문번호를 설정하시기 바랍니다.
#
#    var urls ="http://www.allatpay.com/servlet/AllatBizPop/member/pop_card_receipt.jsp?shop_id=상점아이디&order_no=주문번호";
#    window.open(urls,"app","width=410,height=650,scrollbars=0");
#
#    현금영수증 전표 또는 거래확인서 출력에 대한 문의는 올앳페이 사이트의 1:1상담을 이용하시거나
#    02) 3788-9990 으로 전화 주시기 바랍니다.
#
#    전표출력 페이지는 저희 올앳 홈페이지의 일부로써, 홈페이지 개편 등의 이유로 인하여 페이지 변경 또는 URL 변경이 있을 수
#    있습니다. 홈페이지 개편에 관한 공지가 있을 경우, 전표출력 URL을 확인하시기 바랍니다.
