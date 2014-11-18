$(function(){
  $("#info_button").on("click",function(){
    var country = $("#info_country").val()
    var phonenumber = $("#info_phonenumber").val()
    var postcode = $("#info_postcode").val()
    var address_1 = $("#info_address_1").val()
    var address_2 = $("#info_address_2").val()
    var address_3 = $("#info_address_3").val()

    $.ajax({
      url: "/mypage/api_info/",
      type: "POST",
      dataType:"JSON",
      data: {
        country: country,
        phonenumber:phonenumber,
        postcode:postcode,
        address_1:address_1,
        address_2:address_2,
        address_3:address_3
      },
      success: function(data) {
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
      }
    })
  })
}) 

