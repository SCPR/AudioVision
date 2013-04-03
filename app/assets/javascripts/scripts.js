jQuery(document).ready(function($) {




	
/*	-----------------------------------------------------------------------------------------------------------------
	Are we tapping or clicking?
	----------------------------------------------------------------------------------------------------------------- */
	function is_touch_device() {
	  return !!('ontouchstart' in window) // works on most browsers 
	      || !!('onmsgesturechange' in window); // works on ie10
	};




/*	-----------------------------------------------------------------------------------------------------------------
	Masthead & Ledge interactions
	----------------------------------------------------------------------------------------------------------------- */
	if(is_touch_device() == true) {

			$(".masthead .inside, .ledge .nav-av .menu, .ledge .nav-kpcc .inside").each(function(){
				$(this).click(function(){
					if($(this).hasClass("revealed")) {
						$(this).removeClass("revealed");
					} else {
						$(".masthead .inside, .ledge .nav-av .menu, .ledge .nav-kpcc .inside").removeClass("revealed");
						$(this).addClass("revealed");
					}
				});
			});

	} else {
			
			$(".masthead .inside, .ledge .nav-av .menu, .ledge .nav-kpcc .inside").each(function(){
				$(this).hover(function(){
					$(this).toggleClass("revealed");
				});
			});

	}




/*	-----------------------------------------------------------------------------------------------------------------
	Ledge stickiness
	----------------------------------------------------------------------------------------------------------------- */
	$(".ledge").waypoint("sticky", {
	  offset: 30 // Apply "stuck" when element 30px from top
	});





/*	-----------------------------------------------------------------------------------------------------------------
	Ephemeral styling
	----------------------------------------------------------------------------------------------------------------- */
	if ($(".essay .prose p").length) {
		$(".essay .prose p:first").addClass("first");
	}



});