class Purchase < ActiveRecord::Base
  include AllatUtil
  has_many :orders
  belongs_to  :user
  AT_CROSS_KEY = "efb017021539bb77f652893aca3f05a1"     #설정필요 [사이트 참조 - http://www.allatpay.com/servlet/AllatBiz/support/sp_install_guide_scriptapi.jsp#shop]
  AT_KRW_SHOP_ID   = "oppabox"          #설정필요
  AT_USD_SHOP_ID   = "usd_oppbox"       #설정필요

  def krw_billing params
    process all_krw_price, params[:allat_enc_data], params[:allat_test_yn], AT_KRW_SHOP_ID
  end

  def all_krw_price
    at_amt = 0
    self.orders.each do |o|
      at_amt += o.total_price.to_i * o.quantity.to_i
    end
    at_amt += get_delivery_fee
  end

  def get_delivery_fee
    0
  end

  def process allat_amt, allat_enc_data, allat_test_yn, at_shop_id
    at_amt = allat_amt
    at_data = "allat_shop_id=" + at_shop_id +
               "&allat_amt=" + at_amt.to_s +
               "&allat_enc_data=" + allat_enc_data +
               "&allat_cross_key=" + AT_CROSS_KEY
    at_txt = approvalReq(at_data, "SSL")
    replycd = getValue("reply_cd", at_txt) #결과코드
    replymsg = getValue("reply_msg", at_txt) #결과 메세지
    result = ""
    success_flag = allat_test_yn == "Y" ? "0001" : "0000"
    if replycd == success_flag
      order_no         = getValue("order_no",at_txt)
      amt              = getValue("amt",at_txt)
      pay_type         = getValue("pay_type",at_txt)
      approval_ymdhms  = getValue("approval_ymdhms",at_txt)
      seq_no           = getValue("seq_no",at_txt)
      approval_no      = getValue("approval_no",at_txt)
      card_id          = getValue("card_id",at_txt)
      card_nm          = getValue("card_nm",at_txt)
      sell_mm          = getValue("sell_mm",at_txt)
      zerofee_yn       = getValue("zerofee_yn",at_txt)
      cert_yn          = getValue("cert_yn",at_txt)
      contract_yn      = getValue("contract_yn",at_txt)
      save_amt         = getValue("save_amt",at_txt)
      bank_id          = getValue("bank_id",at_txt)
      bank_nm          = getValue("bank_nm",at_txt)
      cash_bill_no     = getValue("cash_bill_no",at_txt)
      escrow_yn        = getValue("escrow_yn",at_txt)
      account_no       = getValue("account_no",at_txt)
      account_nm       = getValue("account_nm",at_txt)
      income_acc_nm    = getValue("income_account_nm",at_txt)
      income_limit_ymd = getValue("income_limit_ymd",at_txt)
      income_expect_ymd= getValue("income_expect_ymd",at_txt)
      cash_yn          = getValue("cash_yn",at_txt)
      hp_id            = getValue("hp_id",at_txt)
      ticket_id        = getValue("ticket_id",at_txt)
      ticket_pay_type  = getValue("ticket_pay_type",at_txt)
      ticket_name      = getValue("ticket_nm",at_txt)

      result += "결과코드              : " + replycd + "\n"
      result += "결과메세지            : " + replymsg + "\n"
      result += "주문번호              : " + order_no + "\n"
      result += "승인금액              : " + amt + "\n"
      result += "지불수단              : " + pay_type + "\n"
      result += "승인일시              : " + approval_ymdhms + "\n"
      result += "거래일련번호          : " + seq_no + "\n"
      result += "에스크로 적용 여부    : " + escrow_yn + "\n"
      self.replycd = replycd
      self.replymsg = replymsg
      self.order_no = order_no
      self.amt = amt
      self.pay_type = "#{bank_nm} : #{account_no} (#{account_nm})" if pay_type == "VBANK"
      self.approval_ymdhms = approval_ymdhms
      self.seq_no = seq_no
      self.status = PURCHASE_PAID
      result += "=============== 신용 카드 ===============================\n"
      result += "승인번호              : " + approval_no + "\n"
      result += "카드ID                : " + card_id + "\n"
      result += "카드명                : " + card_nm + "\n"
      result += "할부개월              : " + sell_mm + "\n"
      result += "무이자여부            : " + zerofee_yn + "\n";   #무이자(Y),일시불(N
      result += "인증여부              : " + cert_yn + "\n";      #인증(Y),미인증(N
      result += "직가맹여부            : " + contract_yn + "\n";  #3자가맹점(Y),대표가맹점(N
      result += "세이브 결제 금액      : " + save_amt + "\n"
      result += "=============== 계좌 이체 / 가상계좌 ====================\n"
      result += "은행ID                : " + bank_id + "\n"
      result += "은행명                : " + bank_nm + "\n"
      result += "현금영수증 일련 번호  : " + cash_bill_no + "\n"
      result += "=============== 가상계좌 ================================\n"
      result += "계좌번호              : " + account_no + "\n"
      result += "입금계좌명            : " + income_acc_nm + "\n"
      result += "입금자명              : " + account_nm + "\n"
      result += "입금기한일            : " + income_limit_ymd + "\n"
      result += "입금예정일            : " + income_expect_ymd + "\n"
      result += "현금영수증신청 여부   : " + cash_yn + "\n"
      result += "=============== 휴대폰 결제 =============================\n"
      result += "이동통신사구분        : " + hp_id + "\n"
      result += "=============== 상품권 결제 =============================\n"
      result += "상품권 ID             : " + ticket_id + "\n"
      result += "상품권 이름           : " + ticket_name + "\n"
      result += "결제구분              : " + ticket_pay_type + "\n"
    else
      result += "결과코드  : " + replycd.inspect + "\n";
      result += "결과메세지: " + replymsg.inspect + "\n";
      self.replycd = replycd
      self.replymsg = replymsg
    end

    logger.info result

    ActiveRecord::Base.transaction do
      #ITEM QUANTITY
      self.orders.each do |x|
        i = x.item
        if i.limited == true
          i.quantity -= x.quantity
          if i.quantity >= 0
            i.save
          else
            #TODO : RAISE ERROR HERE
            return false
          end
        end

        x.order_option_items.each do |y|
          option_item = y.option_item
          if option_item.limited == true
            option_item.quantity -= x.quantity
            if option_item.quantity >= 0
              option_item.save
            else
              #TODO : RAISE ERROR HERE
              return false
            end
          end
        end
      end

      self.save
    end

    is_success = replycd == success_flag
    return {is_success: is_success, msg: replymsg}
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
