$(function(){
  $("#purchase").click(function(){
    $.ajax({
      data: {
        item_id: 1
      },
      url: '/pay/submit_item',
      type: 'POST',
      success: function(){
        window.location.href = "/pay/billing";
      },
      error: function(xhr){
        alert(xhr.responseText);
      }
    });
  });
});
