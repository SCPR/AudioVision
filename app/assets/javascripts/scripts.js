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
	Billboard slideshows
	----------------------------------------------------------------------------------------------------------------- */
	if ($(".billboard .filmstrip").length) {
		
		// 1.)	Let's fade out the first & third image.
		$(".billboard .filmstrip img:first,.billboard .filmstrip img:last").css("opacity",0.5);

		// 2.)	If we're dealing with squares, then let's adjust the westward positioning.
		//		Since I'm lacking a better idea, let's go with "any ratio higher than 0.85 is a square, and anything less is a rectangle."
		var sampleWidth = $(".billboard .filmstrip img:first").width();
		var sampleHeight = $(".billboard .filmstrip img:first").height();
		var sampleRatio = sampleWidth / sampleHeight;
		//alert("We're dealing with " + sampleWidth + " x " + sampleHeight + ", which calculates out to " + sampleRatio);
		if(sampleRatio > 0.85) {
			$(".billboard").addClass("aspect-ratio-square");
		} else {
			$(".billboard").addClass("aspect-ratio-rect");
		}

	}	




/*	-----------------------------------------------------------------------------------------------------------------
	Ledge stickiness
	----------------------------------------------------------------------------------------------------------------- */
	$(".ledge").waypoint("sticky", {
	  offset: 30 // Apply "stuck" when element 30px from top
	});



/*	-----------------------------------------------------------------------------------------------------------------
	Fakin' media queries
	----------------------------------------------------------------------------------------------------------------- */
	if ($(".newsbox").length) {
		
		// 1.) on load
		if ($("body").innerWidth() <= 940){	
			$(".newsbox").appendTo(".exhibit .secondary");
		}

		// 2.) on resize
		$(window).resize(function(){
			if ($("body").innerWidth() <= 940){	
				$(".newsbox").appendTo(".exhibit .secondary");
			} else {
				$(".newsbox").appendTo(".exhibit .primary");
			}
		});

	}
	




/*	-----------------------------------------------------------------------------------------------------------------
	Ephemeral styling
	----------------------------------------------------------------------------------------------------------------- */
	if ($(".essay .prose p").length) {
		$(".essay .prose p:first").addClass("first");
	}



});