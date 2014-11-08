$(function(){
  $("#signup_step2_button").on("click",function(){
    var email = $("#signup_email").val()
    var password = $("#signup_password").val()
    var password_confirm = $("#signup_password_confirm").val()
    var params_check = check_sign_params(email, password, password_confirm)
    if(params_check.result){
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
    }else{
      alert(params_check.message)
    }
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

    var params_check = check_sign_params(email,password)
    if(params_check){
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
    }
  })
})

function check_sign_params(email, password, password_confirm) {
  if(password_confirm == null){
    password_confirm = password
  }
  ret = new Object
  ret.result = true
  if(!validateEmail(email)){
    ret.result = false
    ret.message =I18n['usercheck_invalid_email']
  }else if(password.length < 8){
    ret.result = false
    ret.message =I18n['usercheck_password_short_length']
  }else if(password != password_confirm){
    ret.result = false
    ret.message = I18n['usercheck_password_confirm_not_equal']
  }
  return ret
}

function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}
