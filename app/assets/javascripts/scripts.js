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
		//		Only run this after our reference image loads, however.

		$(".billboard .filmstrip").imagesLoaded(function() {

			var sampleRatio = 0.66;

			var sampleWidth = $(".billboard .filmstrip img:first").width();
			var sampleHeight = $(".billboard .filmstrip img:first").height();
			sampleRatio = sampleHeight / sampleWidth;
			//alert("sampleWidth is: " + sampleWidth + " ...and sampleHeight is: " + sampleHeight + " ...and sampleRatio is: " + sampleRatio);
			if(sampleRatio > 0.85) {
				$(".billboard").addClass("aspect-ratio-square");
			} else if(sampleRatio > 0.78 && sampleRatio < 0.85) {
				$(".billboard").addClass("aspect-ratio-squarish");
			}

		});

	}	




/*	-----------------------------------------------------------------------------------------------------------------
	Sometimes letterboxing needs to go vertically, not just horizontally
	----------------------------------------------------------------------------------------------------------------- */
	if ($(".feedgrid").length) {
		var feedimgWidth;
		var feedimgHeight;
		var feedimgRatio;
		$(".feedgrid article").each(function(){
			feedimgWidth = $(this).find("img").width();
			feedimgHeight = $(this).find("img").height();
			feedimgRatio = feedimgWidth / feedimgHeight;
//			$(this).prepend("<p style=\"color: red;\">" + feedimgRatio + "</p>");
		});
	}




/*	-----------------------------------------------------------------------------------------------------------------
	If any video embed(s) show up inside a single post
	----------------------------------------------------------------------------------------------------------------- */
	if ($(".single .essay .prose iframe").length) {
		$(".single .essay .prose iframe").each(function(){
			$(this)
				.removeAttr("width height")
				.wrap("<div class=\"media-scaler\"></div>");
		});
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
	// 1.) Single posts
	if ($(".essay .prose p").length) {
		$(".essay .prose p:first").addClass("first");
	}
	
	// 2.) Novella pages
	if ($(".novella .prose p").length) {
		$(".novella .prose p:first").addClass("first");
	}


/*	-----------------------------------------------------------------------------------------------------------------
	FancyBox (for gallery-grid)
	----------------------------------------------------------------------------------------------------------------- */
	if ($(".gallery-grid").length) {
		$(".figure").fancybox();
	}


/*	-----------------------------------------------------------------------------------------------------------------
	Slideshows
	----------------------------------------------------------------------------------------------------------------- */
	$(document).on("webkitfullscreenchange mozfullscreenchange fullscreenchange", function(){
		$("body").toggleClass("av-fullscreen");
	});









});
