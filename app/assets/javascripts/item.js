$(function(){
  function add_to_basket(id, callback) {
    $.ajax({
      data: {
        item_id: id
      },
      url: '/item/add_to_basket',
      type: 'POST',
      success: callback,
      error: function(httpObj) {
        if(httpObj.status == 401){
          window.location.href = "/home/login";
        }else{
          alert(httpObj.responseText);
        }
      }
    });
  }
  function add_to_order(id, qty, callback) {
    $.ajax({
      data: {
        item_id: id,
        quantity: qty
      },
      url: '/item/add_to_order',
      type: 'POST',
      success: callback,
      error: function(httpObj) {
        if(httpObj.status == 401){
          window.location.href = "/home/login";
        }else{
          alert(httpObj.responseText);
        }
      }
    });
  }
  function del_from_basket(id, callback) {
    $.ajax({
      data: {
        item_id: id,
      },
      url: '/item/del_from_basket',
      type: 'POST',
      success: callback,
      error: function(httpObj) {
        if(httpObj.status == 401){
          window.location.href = "/home/login";
        }else{
          alert(httpObj.responseText);
        }
      }
    });
  }
  function del_from_order(id, callback) {
    $.ajax({
      data: {
        item_id: id,
      },
      url: '/item/del_from_order',
      type: 'POST',
      success: callback,
      error: function(httpObj) {
        if(httpObj.status == 401){
          window.location.href = "/home/login";
        }else{
          alert(httpObj.responseText);
        }
      }
    });
  }
  $(".move_to_order").click(function() {
    var id = $(this).data("id");
    add_to_order(id, function() {
      del_from_basket(id, function() {
        window.location.href = "/pay/order";
      });
    });
  });
  $("#add_to_cart").click(function() {
    var id = $("#item_detail_quantity").data("id");
    add_to_basket(id, function() {
      alert("장바구니에 추가되었습니다");
    });
  });
  $("#purchase").click(function() {
    var quantity = $("#item_detail_quantity").val();
    var id = $("#item_detail_quantity").data("id");
    add_to_order(id, quantity, function() {
      window.location.href = "/pay/order";
    });
  });
  $(".del_from_basket").click(function() {

  })
});
