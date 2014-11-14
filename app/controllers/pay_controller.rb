class PayController < ApplicationController
  include AllatUtil
  AT_CROSS_KEY = "efb017021539bb77f652893aca3f05a1"     #설정필요 [사이트 참조 - http://www.allatpay.com/servlet/AllatBiz/support/sp_install_guide_scriptapi.jsp#shop]
  AT_SHOP_ID   = "oppabox"       #설정필요

  def billing
    at_amt = 1000 # test
    at_data = "allat_shop_id=" + AT_SHOP_ID +
               "&allat_amt=" + at_amt.to_s +
               "&allat_enc_data=" + params[:allat_enc_data] +
               "&allat_cross_key=" + AT_CROSS_KEY
    at_txt = approvalReq(at_data, "SSL")
    logger.debug "===== #{at_txt} // #{at_txt.class}"
    replycd = getValue("reply_cd", at_txt) #결과코드
    logger.debug "///// #{replycd} // #{replycd.class}"
    replymsg = getValue("reply_msg", at_txt) #결과 메세지
#  // 결과값 처리
#  //--------------------------------------------------------------------------
#  // 결과 값이 '0000'이면 정상임. 단, allat_test_yn=Y 일경우 '0001'이 정상임.
#  // 실제 결제   : allat_test_yn=N 일 경우 reply_cd=0000 이면 정상
#  // 테스트 결제 : allat_test_yn=Y 일 경우 reply_cd=0001 이면 정상
#  //--------------------------------------------------------------------------
    result = "<h1>Result<h1><hr>"
    if replycd == "0001"
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

      result += "결과코드              : " + replycd + "<br>"
      result += "결과메세지            : " + replymsg + "<br>"
      result += "주문번호              : " + order_no + "<br>"
      result += "승인금액              : " + amt + "<br>"
      result += "지불수단              : " + pay_type + "<br>"
      result += "승인일시              : " + approval_ymdhms + "<br>"
      result += "거래일련번호          : " + seq_no + "<br>"
      result += "에스크로 적용 여부    : " + escrow_yn + "<br>"
      result += "=============== 신용 카드 ===============================<br>"
      result += "승인번호              : " + approval_no + "<br>"
      result += "카드ID                : " + card_id + "<br>"
      result += "카드명                : " + card_nm + "<br>"
      result += "할부개월              : " + sell_mm + "<br>"
      result += "무이자여부            : " + zerofee_yn + "<br>";   #무이자(Y),일시불(N
      result += "인증여부              : " + cert_yn + "<br>";      #인증(Y),미인증(N
      result += "직가맹여부            : " + contract_yn + "<br>";  #3자가맹점(Y),대표가맹점(N
      result += "세이브 결제 금액      : " + save_amt + "<br>"
      result += "=============== 계좌 이체 / 가상계좌 ====================<br>"
      result += "은행ID                : " + bank_id + "<br>"
      result += "은행명                : " + bank_nm + "<br>"
      result += "현금영수증 일련 번호  : " + cash_bill_no + "<br>"
      result += "=============== 가상계좌 ================================<br>"
      result += "계좌번호              : " + account_no + "<br>"
      result += "입금계좌명            : " + income_acc_nm + "<br>"
      result += "입금자명              : " + account_nm + "<br>"
      result += "입금기한일            : " + income_limit_ymd + "<br>"
      result += "입금예정일            : " + income_expect_ymd + "<br>"
      result += "현금영수증신청 여부   : " + cash_yn + "<br>"
      result += "=============== 휴대폰 결제 =============================<br>"
      result += "이동통신사구분        : " + hp_id + "<br>"
      result += "=============== 상품권 결제 =============================<br>"
      result += "상품권 ID             : " + ticket_id + "<br>"
      result += "상품권 이름           : " + ticket_name + "<br>"
      result += "결제구분              : " + ticket_pay_type + "<br>"
    else
      result += "결과코드  : " + replycd.inspect + "<br>";
      result += "결과메세지: " + replymsg.inspect + "<br>";
    end
    render :text => result
  end

  def success
  end

  def order

  end
end

#<?php
#  // 올앳관련 함수 Include
#  //----------------------
#  include "./allatutil.php";
#
#  //Request Value Define
#  //----------------------
#  /********************* Service Code *********************/
#                                         //( session, DB 사용 )
#  /*********************************************************/
#
#  // 요청 데이터 설정
#  //----------------------
#
#
#
#  // 올앳 결제 서버와 통신 : ApprovalReq->통신함수, $at_txt->결과값
#  //----------------------------------------------------------------
#  // 이 부분에서 로그를 남기는 것이 좋습니다.
#  // (올앳 결제 서버와 통신 후에 로그를 남기면, 통신에러시 빠른 원인파악이 가능합니다.)
#
#  // 결제 결과 값 확인
#  //------------------
#  if( !strcmp($REPLYCD,"0000") ){
#    // reply_cd "0000" 일때만 성공
#
#
#  }else{
#  }
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
