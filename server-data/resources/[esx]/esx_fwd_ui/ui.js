$(function(){
	window.addEventListener('message', function(event) {
        if (event.data.action == "updateStatus") {
            updateStatus(event.data.status);
        }else if (event.data.action == "setProximity"){
            setProximity(event.data.value);
		}else if (event.data.action == "setTalking"){
			setTalking(event.data.value);
		}else if (event.data.action == "hideui"){
			$('#hunger').hide();
			$('#thirst').hide();
			$('#drunk').hide();
			$('body').hide();
		}else if (event.data.action == "showui"){
			$('#hunger').show();
			$('#thirst').show();
			$('#drunk').show();
			$('body').show();
		}
    });
});
function setProximity(value){
	var color;
	var speaker;
	var percent;
	if (value == "0"){
		color = "rgb(110, 110, 110)"
		speaker = 1;
		percent = 30;
	}else if (value == "1"){
		color = "rgb(110, 110, 110)"
		speaker = 2;
		percent = 50;
	}else if (value == "2"){
		color = "rgb(110, 110, 110)"
		speaker = 3;
		percent = 100;
	}
	$('#boxDrunk').css('width', percent+'%')
	$('#boxDrunk').css('background', color);
}

function setTalking(value){
	if (value){
		$('#boxDrunk').css('background', '#FF0000');
	}else{
		$('#boxDrunk').css('background-color', 'rgb(110, 110, 110)');
	}
}

function updateStatus(status){
	var hunger = status[0]
	var thirst = status[1]
	$('#boxHunger').css('width', hunger.percent+'%')
	$('#boxThirst').css('width', thirst.percent+'%')
}