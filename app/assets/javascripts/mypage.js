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
}) 

