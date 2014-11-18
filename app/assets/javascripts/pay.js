function total_Price(id,sale_price){
	var $ob=$(".o_quantity").eq(id);
	var data=$ob.val();
	var type=Number(data);
	if(data != " " ){						//수량에 값이 있을 때 실행 (js.erb로 루비들을 불러오면 파일을 불러올 수 없어서 이렇게 해놨습니다.)
		if(!isNaN(type)){				//수량이 숫자일때만 실행
				
			var data_id=$ob.data("id");						//수량 값을 ajax로 전송해서 초기화.
			fix_to_order(data_id, data, function(){
				window.location.href="/pay/order";
			});
			$ob.parent().parent().next().children().html(data*sale_price);	
		}else{
			alert("숫자만 입력해주세요.");
			return;
		}	
	}else{
			alert("값을 입력해주세요.");
			return;
	}
}

function fix_to_order(id, qty, callback) {
  if (callback == undefined) {
    callback = function() {
      window.location.href = "/pay/order";
    }
  }
  $.ajax({
    data: {
      item_id: id,
      quantity: qty,
    },
    url: '/pay/fix_to_order',
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
