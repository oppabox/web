$(function(){
  $("#krw_payment_submit").click(function(){
    $.ajax({
      url: '/pay/check_order_quantity',
      type: 'GET',
      success: function(){
        submit_address("/pay/korean_payment");
      },
      error: function(httpObj) {
        if(httpObj.status == 401){
          window.location.href = "/home/login";
        }else{
          alert(httpObj.responseText);
        }
      }
    });
  });
});

function reorder_quantity(method, order_id){
  $.ajax({
    data: {
      order_id: order_id,
      method: method
    },
    url: '/pay/reorder_quantity',
    type: 'POST',
    success: function(){
      window.location.href = "/pay/order";
    },
    error: function(httpObj) {
      if(httpObj.status == 401){
        window.location.href = "/home/login";
      }else{
        alert(httpObj.responseText);
      }
    }
  });
}
