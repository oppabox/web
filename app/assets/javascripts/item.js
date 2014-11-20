$(function(){
  $("#item_detail_quantity").on("change", function(){
    var total_price = $(this).val() * $("#total_price").data("original-price");
    $("#total_price").html(formatNumber(total_price));
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
});
function formatNumber (num) {
  return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")
}
function move_to_order(id) {
  add_to_order(id, 1, function() {
    del_from_basket(id, function() {
      window.location.href = "/pay/order";
    });
  });
}
function move_to_basket(id) {
  del_from_order(id, function() {
    add_to_basket(id, function() {
      window.location.href = "/pay/order";
    });
  });
}
function add_to_basket(id, callback) {
  if (callback == undefined) {
    callback = function() {
      window.location.href = "/pay/order";
    }
  }
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
  if (callback == undefined) {
    callback = function() {
      window.location.href = "/pay/order";
    }
  }
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
  if (callback == undefined) {
    callback = function() {
      window.location.href = "/pay/order";
    }
  }
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
  if (callback == undefined) {
    callback = function() {
      window.location.href = "/pay/order";
    }
  }
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
