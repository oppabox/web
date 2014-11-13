class PayController < ApplicationController
  def billing
    include AllatUtil
    At_cross_key = "가맹점 CrossKey";     #설정필요 [사이트 참조 - http://www.allatpay.com/servlet/AllatBiz/support/sp_install_guide_scriptapi.jsp#shop]
    At_shop_id   = "가맹점 ShopId";       #설정필요
    At_amt=0;                             #결제 금액을 다시 계산해서 만들어야 함(해킹방지)
    at_data = "allat_shop_id=" + At_shop_id +
               "&allat_amt=" + At_amt +
               "&allat_enc_data=" + params[:allat_enc_data] +
               "&allat_cross_key=" + At_cross_key
    at_txt = approvalReq(at_data,"SSL")
    logger.info "REQUEST_LOG :: " + at_txt
    replycd = getValue("reply_cd", at_txt) #결과코드
    replymsg = getValue("reply_msg", at_txt) #결과 메세지
    logger.debug replymsg
#  // 결과값 처리
#  //--------------------------------------------------------------------------
#  // 결과 값이 '0000'이면 정상임. 단, allat_test_yn=Y 일경우 '0001'이 정상임.
#  // 실제 결제   : allat_test_yn=N 일 경우 reply_cd=0000 이면 정상
#  // 테스트 결제 : allat_test_yn=Y 일 경우 reply_cd=0001 이면 정상
#  //--------------------------------------------------------------------------
    result = "<h1>Result<h1><hr>"
    if replycd == "0001"
      ORDER_NO         =getValue("order_no",at_txt)
      AMT              =getValue("amt",at_txt)
      PAY_TYPE         =getValue("pay_type",at_txt)
      APPROVAL_YMDHMS  =getValue("approval_ymdhms",at_txt)
      SEQ_NO           =getValue("seq_no",at_txt)
      APPROVAL_NO      =getValue("approval_no",at_txt)
      CARD_ID          =getValue("card_id",at_txt)
      CARD_NM          =getValue("card_nm",at_txt)
      SELL_MM          =getValue("sell_mm",at_txt)
      ZEROFEE_YN       =getValue("zerofee_yn",at_txt)
      CERT_YN          =getValue("cert_yn",at_txt)
      CONTRACT_YN      =getValue("contract_yn",at_txt)
      SAVE_AMT         =getValue("save_amt",at_txt)
      BANK_ID          =getValue("bank_id",at_txt)
      BANK_NM          =getValue("bank_nm",at_txt)
      CASH_BILL_NO     =getValue("cash_bill_no",at_txt)
      ESCROW_YN        =getValue("escrow_yn",at_txt)
      ACCOUNT_NO       =getValue("account_no",at_txt)
      ACCOUNT_NM       =getValue("account_nm",at_txt)
      INCOME_ACC_NM    =getValue("income_account_nm",at_txt)
      INCOME_LIMIT_YMD =getValue("income_limit_ymd",at_txt)
      INCOME_EXPECT_YMD=getValue("income_expect_ymd",at_txt)
      CASH_YN          =getValue("cash_yn",at_txt)
      HP_ID            =getValue("hp_id",at_txt)
      TICKET_ID        =getValue("ticket_id",at_txt)
      TICKET_PAY_TYPE  =getValue("ticket_pay_type",at_txt)
      TICKET_NAME      =getValue("ticket_nm",at_txt)

      result += "결과코드              : " + REPLYCD + "<br>"
      result += "결과메세지            : " + REPLYMSG + "<br>"
      result += "주문번호              : " + ORDER_NO + "<br>"
      result += "승인금액              : " + AMT + "<br>"
      result += "지불수단              : " + PAY_TYPE + "<br>"
      result += "승인일시              : " + APPROVAL_YMDHMS + "<br>"
      result += "거래일련번호          : " + SEQ_NO + "<br>"
      result += "에스크로 적용 여부    : " + ESCROW_YN + "<br>"
      result += "=============== 신용 카드 ===============================<br>"
      result += "승인번호              : " + APPROVAL_NO + "<br>"
      result += "카드ID                : " + CARD_ID + "<br>"
      result += "카드명                : " + CARD_NM + "<br>"
      result += "할부개월              : " + SELL_MM + "<br>"
      result += "무이자여부            : " + ZEROFEE_YN + "<br>";   #무이자(Y),일시불(N
      result += "인증여부              : " + CERT_YN + "<br>";      #인증(Y),미인증(N
      result += "직가맹여부            : " + CONTRACT_YN + "<br>";  #3자가맹점(Y),대표가맹점(N
      result += "세이브 결제 금액      : " + SAVE_AMT + "<br>"
      result += "=============== 계좌 이체 / 가상계좌 ====================<br>"
      result += "은행ID                : " + BANK_ID + "<br>"
      result += "은행명                : " + BANK_NM + "<br>"
      result += "현금영수증 일련 번호  : " + CASH_BILL_NO + "<br>"
      result += "=============== 가상계좌 ================================<br>"
      result += "계좌번호              : " + ACCOUNT_NO + "<br>"
      result += "입금계좌명            : " + INCOME_ACC_NM + "<br>"
      result += "입금자명              : " + ACCOUNT_NM + "<br>"
      result += "입금기한일            : " + INCOME_LIMIT_YMD + "<br>"
      result += "입금예정일            : " + INCOME_EXPECT_YMD + "<br>"
      result += "현금영수증신청 여부   : " + CASH_YN + "<br>"
      result += "=============== 휴대폰 결제 =============================<br>"
      result += "이동통신사구분        : " + HP_ID + "<br>"
      result += "=============== 상품권 결제 =============================<br>"
      result += "상품권 ID             : " + TICKET_ID + "<br>"
      result += "상품권 이름           : " + TICKET_NAME + "<br>"
      result += "결제구분              : " + TICKET_PAY_TYPE + "<br>"
    else
      result += "결과코드  : " + REPLYCD + "<br>";
      result += "결과메세지: " + REPLYMSG + "<br>";
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
