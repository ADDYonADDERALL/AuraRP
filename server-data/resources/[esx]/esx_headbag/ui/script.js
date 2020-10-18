$(function(){
	window.onload = function(e){
		window.addEventListener('message', function(event){
			var item = event.data;
			if (item !== undefined) {
				if (item.display === true) {
					
					$('#worek').delay(100).fadeIn( "slow" );
					
					
				} else if (item.display === false) {
					$('#worek').fadeOut( "slow" );
				}
			}
		});
	};
});

