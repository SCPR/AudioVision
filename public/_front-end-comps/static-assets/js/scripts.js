jQuery(document).ready(function($) {



	/*
	/* Masthead & Ledge UI
	$(".masthead .inside, .ledge .nav-av .menu, .ledge .nav-kpcc .inside").each(function(){
			$(this).hover(function(){
				$(this).toggleClass("revealed");
			}).click(function(){
				$(this).toggleClass("revealed");
			}).blur(function(){
				$(this).removeClass("revealed");
			});
	});
	*/
	
	function is_touch_device() {
	  return !!('ontouchstart' in window) // works on most browsers 
	      || !!('onmsgesturechange' in window); // works on ie10
	};
	
	if(is_touch_device() == true) {
		alert("yes, you're on a touch device");
	} else {
		alert("this is a mouse device, not for tapping");
	}


	





});