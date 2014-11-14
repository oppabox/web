$(function(){
  $(".user-info-input").on("keydown",function(e){
    if(e.keyCode == 13){
      $(".user-info-submit").click()
    }
  })
  $("#signup_step2_button").on("click",function(){
    var email = $("#signup_email").val()
    var password = $("#signup_password").val()
    var password_confirm = $("#signup_password_confirm").val()

    $.ajax({
      url: "/home/api_step2/",
      type: "POST",
      dataType:"JSON",
      data: {
        email: email,
        password: password,
        password_confirm: password_confirm
      },
      success: function(data) {
        if(data["result"]){
          location.href="/home/step3"
        }else{
          alert(data["message"])
        }
      }
    })
  })

  $("#signup_step3_button").on("click",function(){
    var country = $("#signup_country").val()
    var phonenumber = $("#signup_phonenumber").val()
    var postcode = $("#signup_postcode").val()
    var address = $("#signup_address").val()

    $.ajax({
      url: "/home/api_step3/",
      type: "POST",
      dataType:"JSON",
      data: {
        country: country,
        phonenumber:phonenumber,
        postcode:postcode,
        address:address
      },
      success: function(data) {
        if(data["result"]){
          location.href="/"
        }else{
          alert(I18n["cannot_signup"])
        }
      }
    })
  })

  $("#signin_button").on("click",function(){
    var email = $("#signin_email").val()
    var password = $("#signin_password").val()

    $.ajax({
      url: "/home/api_login/",
      type: "POST",
      dataType:"JSON",
      data: {
        email:email,
        password:password
      },
      success: function(data) {
        if(data["result"]){
          location.href="/"
        }else{
          alert(data["message"])
        }
      }
    })
  })

  $("#renew_password_button").on("click",function(){
    var password = $("#renew_password").val()
    var password_confirm = $("#renew_password").val()
    $.ajax({
      url: "/home/api_renew_password/",
      type: "POST",
      dataType:"JSON",
      data: {
        password: password,
        password_confirm:password_confirm
      },
      success: function(data) {
        alert(data["message"])
        if(data["result"]){
          location.href = "/"
        }
      }
    })
  })
  $("#reset_password_button").on("click",function(){
    var email = $("#reset_password_email").val()
    $.ajax({
      url: "/home/api_reset_password/",
      type: "POST",
      dataType:"JSON",
      data: {
        email: email
      },
      success: function(data) {
        alert(data["message"])
        if(data["result"]){
          location.href = "/"
        }
      }
    })
  })
})

