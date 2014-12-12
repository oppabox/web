$(function(){
  $("#item_detail_quantity").on("change", function(){
    var total_price = $(this).val() * $("#total_price").data("original-price");
    $("#total_price").html(formatNumber(total_price));
  });
  $("#add_to_cart").click(function() {
    var id = $("#item_detail_quantity").data("id");
    add_to_basket(id, function(data) {
      var r = confirm(data);
      if (r == true) {
        window.location.href = "/mypage/basket";
      }
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
      location.reload();
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

function go_top(orix,oriy,desx,desy) {
  var Timer;
  if (document.body.scrollTop == 0) {
    var winHeight = document.documentElement.scrollTop;
  } else {
    var winHeight = document.body.scrollTop;
  }
  if(Timer) clearTimeout(Timer);
  startx = 0;
  starty = winHeight;
  if(!orix || orix < 0) orix = 0;
  if(!oriy || oriy < 0) oriy = 0;
  var speed = 7;
  if(!desx) desx = 0 + startx;
  if(!desy) desy = 0 + starty;
  desx += (orix - startx) / speed;
  if (desx < 0) desx = 0;
  desy += (oriy - starty) / speed;
  if (desy < 0) desy = 0;
  var posX = Math.ceil(desx);
  var posY = Math.ceil(desy);
  window.scrollTo(posX, posY);
  if((Math.floor(Math.abs(startx - orix)) < 1) && (Math.floor(Math.abs(starty - oriy)) < 1)){
    clearTimeout(Timer);
    window.scroll(orix,oriy);
  }else if(posX != orix || posY != oriy){
    Timer = setTimeout("go_top("+orix+","+oriy+","+desx+","+desy+")",15);
  }else{
    clearTimeout(Timer);
  }
}
