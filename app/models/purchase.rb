class Purchase < ActiveRecord::Base
  include AllatUtil
  has_many :orders
  belongs_to  :user
  AT_CROSS_KEY = "efb017021539bb77f652893aca3f05a1"     #설정필요 [사이트 참조 - http://www.allatpay.com/servlet/AllatBiz/support/sp_install_guide_scriptapi.jsp#shop]
  AT_SHOP_ID   = "oppabox"       #설정필요

  def billing allat_amt, allat_enc_data, allat_test_yn
    at_amt = allat_amt
    at_data = "allat_shop_id=" + AT_SHOP_ID +
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
      self.pay_type = pay_type
      self.approval_ymdhms = approval_ymdhms
      self.seq_no = seq_no
      self.status = "paid"
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
    self.save
    replycd == success_flag
  end
end
