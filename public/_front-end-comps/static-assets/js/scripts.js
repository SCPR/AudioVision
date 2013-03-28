jQuery(document).ready(function($) {



	/* Masthead UI */
	$(".masthead .inside").hover(function(){
		$(this).toggleClass("revealed");
	}).click(function(){
		$(this).toggleClass("revealed");
	}).blur(function(){
		$(this).removeClass("revealed");
	});

	





});