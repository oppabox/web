#encoding=utf-8
module AllatUtil
  require 'socket'
  require 'openssl'
  require 'iconv'

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
    if ssl_flag == "SSL"
      ret_txt = sendRepo(at_data, Allat_addr_ssl, Approval_uri, Allat_host, 443)
    else
      if checkEnc(at_data)
        ret_txt = sendRepo(at_data, Allat_addr, Approval_uri, Allat_host, 80)
      else
        ret_txt = "reply_cd=0230\nreply_msg=암호화오류\n"
      end
    end
    ret_txt
  end

  def sanctionReq at_data, ssl_flag
    ret_txt = "reply_cd=0299\n"
    if ssl_flag == "SSL"
      ret_txt = sendRepo(at_data, Allat_addr_ssl, Sanction_uri, Allat_host, 443 )
    else
      if checkEnc(at_data)
        ret_txt = SendRepo(at_data, allat_addr, sanction_uri, allat_host, 80)
      else
        ret_txt = "reply_cd=0230\nreply_msg=암호화오류\n"
      end
    end
    ret_txt
  end

private

  def sendRepo req_data, req_addr, req_url, req_host, req_port
    resp_txt = "reply_cd=0299\n"
    date_time = Time.now.strftime('%Y%m%d%H%M%S')
    util_ver="&allat_opt_lang=" + Util_lang + "&allat_opt_ver=" + Util_ver
    req_data= req_data + "&allat_apply_ymdhms=" + date_time
    send_data = req_data + util_ver
    at_sock = TCPSocket.new(req_host, req_port)
    ctx = OpenSSL::SSL::SSLContext.new
    ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
    at_sock = OpenSSL::SSL::SSLSocket.new(at_sock, ctx)
    at_sock.sync = true
    at_sock.connect
    if at_sock
      logger.debug "SEND_DATA ::\n" + send_data.to_s
      data = ""
      data << req_url
      data << "Host: #{req_host}:#{req_port}\r\n"
      data << "Content-type: application/x-www-form-urlencoded\r\n"
      data << "Content-length: #{send_data.length}\r\n"
      data << "Accept: */*\r\n"
      data << "\r\n"
      data << "#{send_data}\r\n\r\n"
      at_sock.puts(data)
      response = at_sock.read
      logger.debug "RESPONSE_LOG ::\n" +  response.to_s
      conv = Iconv.new('UTF-8//IGNORE', 'EUC-KR')
      resp_txt_origin = response.split("\r\n\r\n", 2)[1]
      resp_txt = conv.iconv(resp_txt_origin)
      logger.debug "RESPONSE_DATA ::\n" + resp_txt
    else
      resp_txt = "reply_cd=0212\nreply_msg=Socket Connect Error:#{"error"}\n"
    end
    return resp_txt
  end

  def getValue nameVal, textVal
    textVal = textVal || ""
    temp = textVal.delete(" ").split("\n")
    ret = ""
    temp.each do |t|
      retVal = t.split('=')
      if retVal[0] == nameVal
        ret = retVal[1] || ""
      end
    end
    return ret
  end

  def checkEnc srcstr
    posno = srcstr.index("allat_enc_data=")
    return false if posno.nil?
    checksum = srcstr[posno + "allat_enc_data=".length + 5]
    logger.debug "CHECKSUM : " + checksum
    return false if checksum != "1"
    return true
  end

  def setValue retData, insKey, insValue
    if retData.length == 0
      tmpData = "00000010" + insKey  + "^C" + insValue + "^X"
    else
      tmpData = retData + insKey + "^C" + insValue + "^X"
    end
    return tmpData
  end
end
