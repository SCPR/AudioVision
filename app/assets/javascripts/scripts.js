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
	Billboards!
	----------------------------------------------------------------------------------------------------------------- */		
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
		if(sampleRatio > 0.85) {
			$(".billboard").addClass("aspect-ratio-square");
		} else if(sampleRatio > 0.78 && sampleRatio < 0.85) {
			$(".billboard").addClass("aspect-ratio-squarish");
		}
	});
	
	// 3.) Sometimes, titles & subtitles can just be too damn long.
	$(".billboard .row.secondary .component").each(function(){
		var titleMax = 35;
		var subtitleMax = 50;
		var myTitleChars = $(this).find(".title span").html().length;
		var mySubtitleChars = $(this).find(".subtitle span").html().length;

		if(myTitleChars > titleMax) {
			$(this).find(".title").addClass("verbose");
		}
		if(mySubtitleChars > subtitleMax) {
			$(this).find(".subtitle").addClass("verbose");
		}
	});




/*	-----------------------------------------------------------------------------------------------------------------
	Here & there ratios (sorry for the redundancy)
	~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
	Credit to: http://stackoverflow.com/a/9210902
	----------------------------------------------------------------------------------------------------------------- */
	$(".single-plugs recently").imagesLoaded(function() {
		$(".single-plugs .recently article").each(function(){

			var sampleRatio;
			var sampleWidth = $(this).find("img")[0].naturalWidth;
			var sampleHeight = $(this).find("img")[0].naturalHeight;
			sampleRatio = sampleHeight / sampleWidth;
			if(sampleRatio < 0.65) {
				$(this).addClass("wide");
			}
			
		});
	});




/*	-----------------------------------------------------------------------------------------------------------------
	Media scroll-stickiness
	----------------------------------------------------------------------------------------------------------------- */
	if ($(".exhibit").length) {
		if ($(".exhibit").hasClass("exhibit-type-video")) {		
			// ...
		} else {
			// ...
		}
	}




/*	-----------------------------------------------------------------------------------------------------------------
	Tweaking the "Sandbox" post type
	----------------------------------------------------------------------------------------------------------------- */
	if($(".exhibit-type-sandbox .media-wrapper").length) {
		$(".exhibit").addClass("includes-feature");
	}




/*	-----------------------------------------------------------------------------------------------------------------
	If any video embeds show up in a post, wrap them in a flexible container
	----------------------------------------------------------------------------------------------------------------- */
	$(".prose iframe").each(function(){
		var height, width, padding, scaler;

		height      = $(this).attr('height') || $(this).height();
		width       = $(this).attr('width') || $(this).width();
		padding     = (height/width + 0.2) * 100;

		scaler = $("<div class=\"media-scaler\"></div>");
		scaler.css({'padding-bottom': padding + "%"});

		$(this)
			.removeAttr("width height")
			.wrap(scaler);
	});




/*	-----------------------------------------------------------------------------------------------------------------
	Ledge stickiness
	----------------------------------------------------------------------------------------------------------------- */
	$(".ledge").waypoint("sticky", {
	  offset: 30 // Apply "stuck" when element 30px from top
	});



/*	-----------------------------------------------------------------------------------------------------------------
	Fakin' media queries
	----------------------------------------------------------------------------------------------------------------- */
	if ($(".newsboxes").length) {
		if(!$(".exhibit").hasClass("exhibit-type-sandbox")){

				if ($("body").innerWidth() <= 940){	
					$(".newsboxes").appendTo(".exhibit .secondary");
				}

				$(window).resize(function(){
					if ($("body").innerWidth() <= 940){	
						$(".newsboxes").appendTo(".exhibit .secondary");
					} else {
						$(".newsboxes").appendTo(".exhibit .primary");
					}
				});

		} else {

				if ($("body").innerWidth() >= 940){	
					$(".newsboxes").appendTo(".exhibit .secondary");
				}

				$(window).resize(function(){
					if ($("body").innerWidth() <= 940){	
						$(".newsboxes").appendTo(".exhibit .primary");
					} else {
						$(".newsboxes").appendTo(".exhibit .secondary");
					}
				});
		}

	}




/*	-----------------------------------------------------------------------------------------------------------------
	Ephemeral styling
	----------------------------------------------------------------------------------------------------------------- */
	// 1.) Single posts
	$(".essay .prose p:first").addClass("first");
	
	// 2.) Novella pages
	$(".novella .prose p:first").addClass("first");



/*	-----------------------------------------------------------------------------------------------------------------
	FancyBox (for gallery-grid)
	----------------------------------------------------------------------------------------------------------------- */
	if ($(".gallery-grid").length) {
		$(".figure").fancybox();
	}


/*	-----------------------------------------------------------------------------------------------------------------
	Are we fullscreen?
	----------------------------------------------------------------------------------------------------------------- */
	$(document).on("webkitfullscreenchange mozfullscreenchange fullscreenchange", function(){
		$("body").toggleClass("av-fullscreen");
	});













});
