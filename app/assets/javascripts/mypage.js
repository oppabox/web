$(function(){
  $("#info_button").on("click",function(){
    var phonenumber = $("#info_phonenumber").val()
    var postcode = $("#info_postcode").val()
    var address = $("#info_address").val()

    $.ajax({
      url: "/mypage/api_info/",
      type: "POST",
      dataType:"JSON",
      data: {
        phonenumber:phonenumber,
        postcode:postcode,
        address:address
      },
      success: function(data) {
      },
      error: function(httpObj) {
        if(httpObj.status == 401){
          window.location.href = "/home/login";
        }else{
          alert(httpObj.responseText);
        }
      }
    })
  })
  $("#user_reset_password_button").on("click",function(){
    var current_password = $("#user_current_password").val()
    var password = $("#user_reset_password").val()
    var password_confirm = $("#user_reset_password_confirm").val()
    $.ajax({
      url: "/mypage/api_reset_password/",
      type: "POST",
      dataType:"JSON",
      data: {
        current_password: current_password,
        password: password,
        password_confirm: password_confirm
      },
      success: function(data) {
        alert(data["message"])
        if(data["result"])
          location.reload()
      },
      error: function(httpObj) {
        if(httpObj.status == 401){
          window.location.href = "/home/login";
        }else{
          alert(httpObj.responseText);
        }
      }
    })
  })
  $("#return_request_button").on("click",function(){
    var quantity = $("#return_quantity").val()
    var reason = $("#return_reason").val()
    var reason_detail = $("#return_reason_details").val()
    var sender = $("#signup_name").val()
    var phonenumber = $("#signup_phonenumber").val()
    var postcode = $("#signup_postcode").val()
    var country = $("#signup_country").val()
    var city = $("#signup_city").val()
    var state = $("#signup_state").val()
    var address = $("#signup_address").val()
    var order_id = $("#order_id").val()
    $.ajax({
      url: "/mypage/return_request",
      type: "POST",
      dataType: "JSON",
      data: {
        quantity: quantity,
        reason: reason,
        reason_detail: reason_detail,
        sender: sender,
        phonenumber: phonenumber,
        postcode: postcode,
        country: country,
        city: city,
        address: address,
        order_id: order_id,
        state: state
      },
      success: function(data) {
        alert(data["message"]);
        if (data["result"])
          window.location.href = "/mypage";
      },
      error: function(httpObj) {
        if(httpObj.status == 401){
          window.location.href = "/home/login";
        }else{
          alert(httpObj.responseText);
        }
      }
    })
  })
  $("#cancel_request_button").on("click",function(){
    var quantity = $("#cancel_quantity").val()
    var reason = $("#cancel_reason").val()
    var reason_detail = $("#cancel_reason_details").val()
    var order_id = $("#order_id").val()
    $.ajax({
      url: "/mypage/cancel_request",
      type: "POST",
      dataType: "JSON",
      data: {
        quantity: quantity,
        reason: reason,
        reason_detail: reason_detail,
        order_id: order_id
      },
      success: function(data) {
        alert(data["message"]);
        if (data["result"])
          window.location.href = "/mypage";
      },
      error: function(httpObj) {
        if(httpObj.status == 401){
          window.location.href = "/home/login";
        }else{
          alert(httpObj.responseText);
        }
      }
    })
  })
  $("#change_request_button").on("click",function(){
    var quantity = $("#change_quantity").val()
    var reason = $("#change_reason").val()
    var reason_detail = $("#change_reason_details").val()
    var order_id = $("#order_id").val()
    var sender = $("#signup_name").val()
    var phonenumber = $("#signup_phonenumber").val()
    var postcode = $("#signup_postcode").val()
    var country = $("#signup_country").val()
    var city = $("#signup_city").val()
    var state = $("#signup_state").val()
    var address = $("#signup_address").val()
    $.ajax({
      url: "/mypage/change_request",
      type: "POST",
      dataType: "JSON",
      data: {
        quantity: quantity,
        reason: reason,
        reason_detail: reason_detail,
        sender: sender,
        phonenumber: phonenumber,
        postcode: postcode,
        country: country,
        city: city,
        address: address,
        order_id: order_id,
        state: state
      },
      success: function(data) {
        alert(data["message"]);
        if (data["result"])
          window.location.href = "/mypage";
      },
      error: function(httpObj) {
        if(httpObj.status == 401){
          window.location.href = "/home/login";
        }else{
          alert(httpObj.responseText);
        }
      }
    })
  })

}) 

