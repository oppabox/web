$(function(){
  $("#purchase").click(function(){
    $.ajax({
      data: {
        item_id: 1
      },
      url: '/pay/submit_item',
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
  });
});
