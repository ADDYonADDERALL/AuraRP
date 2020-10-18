$(document).ready(function(){
	
  var number = 0;
  var number2 = 0;
  var number3 = 0;
  
  function closeMain() {
    $(".home").css("display", "none");
  }
  function openMain() {
    $(".home").css("display", "block");
  }
  function closeAll() {
    $(".body").css("display", "none");
  }
  function openContainer() {
    $(".container").css("display", "block");
  }
  function closeContainer() {
    $(".container").css("display", "none");
  }
  
  window.addEventListener('message', function(event){
    var item = event.data;
	
    if(item.openGarage == true) {
      openContainer();
      openMain();
    }
    if(item.openGarage == false) {
      closeContainer();
      closeMain();
    }

    if(item.clearme == true) {
	  for(var i=1; i<=number; i++) {
		if(!$("#btnCar" + i).hasClass('btnCar')) { $("#btnCar" + number).addClass('btnCar');}
	  }
	  number = 0;
    }
	
	if(item.clearimp == true) {
	  for(var i=1; i<=number2; i++) {
		if(!$("#impCar" + i).hasClass('impCar')) { $("#impCar" + number).addClass('impCar');}
	  }
	  number2 = 0;
    }
	
	if(item.clearpolice == true) {
	  for(var i=1; i<=number3; i++) {
		if(!$("#policeCar" + i).hasClass('policeCar')) { $("#policeCar" + number).addClass('policeCar');}
	  }
	  number3 = 0;
    }
	
    if(item.addcar == true) {
	  var car = '<a href="#" class="button sans btnCar" id="btnCar' + item.number + '" model=""></a>';
	  $("#cars").append(car);
      $("#btnCar" + item.number).removeClass('btnCar');
      $("#btnCar" + item.number).html(item.name);
      $("#btnCar" + item.number).attr('model', item.model);
	  number = number + 1;
    }
	
	if(item.impcar == true) {
	  var car = '<a href="#" class="button sans impCar" id="impCar' + item.number + '" model=""></a>';
	  $("#cars").append(car);
      $("#impCar" + item.number).removeClass('impCar');
      $("#impCar" + item.number).html(item.name);
      $("#impCar" + item.number).attr('model', item.model);
	  number2 = number2 + 1;
    }
	
	if(item.policecar == true) {
	  var car = '<a href="#" class="button sans policeCar" id="policeCar' + item.number + '" model=""></a>';
	  $("#cars").append(car);
      $("#policeCar" + item.number).removeClass('policeCar');
      $("#policeCar" + item.number).html(item.name);
      $("#policeCar" + item.number).attr('model', item.model);
	  number3 = number3 + 1;
    }
  });
  
  document.onkeyup = function (data) {
    if (data.which == 27 ) {
      $.post('http://sandy_garages/close', JSON.stringify({}));
		setTimeout(function(){
			if ($('#btnCar1').length > 0) {
				for (var j=1; j<=number; j++) {
					document.getElementById("btnCar" + j).remove();
				}
			} 
			if ($('#impCar1').length > 0) {
				for (var j=1; j<=number2; j++) {
					var elem = document.getElementById("impCar" + j).remove();
				}
			}
			if ($('#policeCar1').length > 0) {
				for (var j=1; j<=number3; j++) {
					var elem = document.getElementById("policeCar" + j).remove();
				}
			}
		}, 500);
    }
  };
  
  document.addEventListener('click',function(e){
	for (var i=1; i<=number; i++) {
		if(e.target && e.target.id == 'btnCar' + i){
			var model = $("#btnCar" + i).attr('model');
			$.post('http://sandy_garages/pullCar',  JSON.stringify({ model: $("#btnCar" + i).attr('model') }));
			setTimeout(function(){
				for (var j=1; j<=number; j++) {
					document.getElementById("btnCar" + j).remove();
				}
			}, 500);
		}
	}
  });
  
  document.addEventListener('click',function(e){
	for (var i=1; i<=number2; i++) {
		if(e.target && e.target.id == 'impCar' + i){
			var model = $("#impCar" + i).attr('model');
			$.post('http://sandy_garages/towCar',  JSON.stringify({ model: $("#impCar" + i).attr('model') }));
			setTimeout(function(){
				for (var j=1; j<=number2; j++) {
					document.getElementById("impCar" + j).remove();
				}
			}, 500);
		}
	}
  });
  
  document.addEventListener('click',function(e){
	for (var i=1; i<=number3; i++) {
		if(e.target && e.target.id == 'policeCar' + i){
			var model = $("#policeCar" + i).attr('model');
			$.post('http://sandy_garages/impoundCar',  JSON.stringify({ model: $("#policeCar" + i).attr('model') }));
			setTimeout(function(){
				for (var j=1; j<=number3; j++) {
					document.getElementById("policeCar" + j).remove();
				}
			}, 500);
		}
	}
  });

	$(".btnClose").click(function(){
		$.post('http://sandy_garages/close', JSON.stringify({}));
		setTimeout(function(){
			if ($('#btnCar1').length > 0) {
				for (var j=1; j<=number; j++) {
					document.getElementById("btnCar" + j).remove();
				}
			} 
			if ($('#impCar1').length > 0) {
				for (var j=1; j<=number2; j++) {
					var elem = document.getElementById("impCar" + j).remove();
				}
			}
			if ($('#policeCar1').length > 0) {
				for (var j=1; j<=number3; j++) {
					var elem = document.getElementById("policeCar" + j).remove();
				}
			}
		}, 500);
    });
});