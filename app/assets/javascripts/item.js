$(function(){
  $("#purchase").click(function(){
    var quantity = $("#item_detail_quantity").val();
    var id = $("#item_detail_quantity").data("id");
    $.ajax({
      data: {
        item_id: id,
        quantity: quantity
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
