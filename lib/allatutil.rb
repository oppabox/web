#encoding=utf-8
class AllatUtil
  require 'socket'

  Util_lang = "PHP"
  Util_ver = "1.0.7.1"

  Approval_uri = "POST /servlet/AllatPay/pay/approval.jsp HTTP/1.0\r\n"
  Sanction_uri = "POST /servlet/AllatPay/pay/sanction.jsp HTTP/1.0\r\n"
  Cancel_uri = "POST /servlet/AllatPay/pay/cancel.jsp HTTP/1.0\r\n"
  Cashreg_uri = "POST /servlet/AllatPay/pay/cash_registry.jsp HTTP/1.0\r\n"
  Cashapp_uri = "POST /servlet/AllatPay/pay/cash_approval.jsp HTTP/1.0\r\n"
  Cashcan_uri = "POST /servlet/AllatPay/pay/cash_cancel.jsp HTTP/1.0\r\n"
  Escrowchk_uri = "POST /servlet/AllatPay/pay/escrow_check.jsp HTTP/1.0\r\n"
  Escrowret_uri = "POST /servlet/AllatPay/pay/escrow_return.jsp HTTP/1.0\r\n"
  Escrowconfirm_uri = "POST /servlet/AllatPay/pay/escrow_confirm.jsp HTTP/1.0\r\n"
  Certreg_uri = "POST /servlet/AllatPay/pay/fix.jsp HTTP/1.0\r\n" 
  Certcancel_uri = "POST /servlet/AllatPay/pay/fix_cancel.jsp HTTP/1.0\r\n"

  C2c_approval_uri = "POST /servlet/AllatPay/pay/c2c_approval.jsp HTTP/1.0\r\n"
  C2c_cancel_uri = "POST /servlet/AllatPay/pay/c2c_cancel.jsp HTTP/1.0\r\n"
  C2c_sellerreg_uri = "POST /servlet/AllatPay/pay/seller_registry.jsp HTTP/1.0\r\n"
  C2c_productreg_uri = "POST /servlet/AllatPay/pay/product_registry.jsp HTTP/1.0\r\n"
  C2c_buyerchg_uri = "POST /servlet/AllatPay/pay/buyer_change.jsp HTTP/1.0\r\n"
  C2c_escrowchk_uri = "POST /servlet/AllatPay/pay/c2c_escrow_check.jsp HTTP/1.0\r\n"
  C2c_escrowconfirm_uri = "POST /servlet/AllatPay/pay/c2c_escrow_confirm.jsp HTTP/1.0\r\n"
  C2c_esrejectcheck_uri = "POST /servlet/AllatPay/pay/c2c_reject_check.jsp HTTP/1.0\r\n"
  C2c_expressreg_uri = "POST /servlet/AllatPay/pay/c2c_express_reg.jsp HTTP/1.0\r\n"

  Allat_addr_ssl = "ssl://tx.allatpay.com" 
  Allat_addr = "tx.allatpay.com"
  Allat_host = "tx.allatpay.com"

  def approvalReq at_data, ssl_flag
    ret_txt = "reply_cd=0299\n"
    if sslflag == "SSL"
      ret_txt = sendRepo(at_data, Allat_addr_ssl, Approval_uri, Allat_host, 443)
    else
      isEnc = checkEnc(at_data)
      if isEnc
        ret_txt = sendRepo(at_data, Allat_addr, Approval_uri, Allat_host, 80)
      else
        ret_txt = "reply_cd=0230\nreply_msg=암호화오류\n"
      end
    end
    return ret_txt
  end

  def sanctionReq at_data, ssl_flag
    ret_txt = "reply_cd=0299\n"
    if ssl_flag == "SSL"
      ret_txt = sendRepo(at_data, Allat_addr_ssl, Sanction_uri, Allat_host, 443 )
    else
      isEnc = checkEnc(at_data);
      if isEnc
        ret_txt = SendRepo(at_data, allat_addr, sanction_uri, allat_host, 80)
      else
        ret_txt = "reply_cd=0230\nreply_msg=암호화오류\n"
      end
    end
    return ret_txt
  end

  def sendRepo srp_data, srp_addr, srp_url, srp_host, srp_port
    ret_txt = sendReq srp_data, srp_addr, srp_url, srp_host, srp_port
  end

  def sendReq req_data, req_addr, req_url, req_host, req_port
    resp_txt = "reply_cd=0299\n"
    date_time = Time.now.strftime('%Y%m%d%H%M%S')
    util_ver="&allat_opt_lang=" + Util_lang + "&allat_opt_ver=" + Util_ver
    req_data= req_data + "&allat_apply_ymdhms=" + date_time
    send_data = req_data + util_ver
    at_sock = TCPSocket.open(req_addr, req_port)
    if at_sock
      at_sock.print(send_data)
      response = at_sock.read
      resp_txt = response.split("\r\n\r\n", 2)[1]
    else
      resp_txt = "reply_cd=0212\nreply_msg=Socket Connect Error:#{"error"}\n"
    end
    return resp_txt
  end

private
  def getValue nameVal, textVal
    temp = textVal.delete(' ').splite('\n')
    temp.each do |t|
      retVal = t.splite('=')
      if retVal[0] = nameVal
        retVal[1]
      end
    end
  end

  def checkEnc srcstr
    posno srcstr.index("allat_enc_data=")
    return false if posno.nil?
    return false if srcstr[posno + "allat_enc_data=".length + 5] != 1
    return true
  end
end
