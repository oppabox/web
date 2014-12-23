$(function(){
  recalculate();
  $(".select_option_box, #periodic_option").on("change", function(){
    recalculate();
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
    var option_array = new Object();
    $(".option_items").each(function(){
      input_value = ""
      if ($(this).data("option-type") == 1){
        input_value = $(this).find('option:selected').val();
      }else{
        input_value = $(this).val();
      }
      option_array[$(this).data("option-id")] = input_value;
    });
    var periodic_month = 1 
    if ($("#periodic_option").length == 1){
      periodic_month = $("#periodic_option").val();
    }
    add_to_order(id, quantity, option_array, periodic_month, function() {
      window.location.href = "/pay/order";
    });
  });
});
function recalculate(){
  var options_total = 0;
  $(".select_option_box").each(function(){
    var selected = $(this).find('option:selected');
    options_total += selected.data('price'); 
  });
  var periodic_month = 1 
  if ($("#periodic_option").length == 1){
    periodic_month = $("#periodic_option").val();
  }
  var total_price = periodic_month * $("#item_detail_quantity").val() * ($("#total_price").data("original-price") + options_total);

  $.ajax({
    data: {
      total_price: total_price
    },
    url: '/pay/change_currency',
    type: 'POST',
    success: function(httpObj){
      $("#total_price").html(httpObj);
    },
    error: function(httpObj) {
      alert(httpObj.responseText);
    }
  });

}
function formatNumber (num) {
  return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")
}
function move_to_order(id) {
  var option_array = new Object();
  add_to_order(id, 1, option_array, 1, function() {
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
function add_to_order(id, qty, options, periodic, callback) {
  if (callback == undefined) {
    callback = function() {
      window.location.href = "/pay/order";
    }
  }
  $.ajax({
    data: {
      item_id: id,
      quantity: qty,
      option_items: options,
      periodic: periodic
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
