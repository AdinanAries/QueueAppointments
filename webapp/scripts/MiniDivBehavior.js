


$(window).scroll(function(){
  if($(window).scrollTop() > 100){
      $("#miniThisNav").fadeIn("slow");
  }
});
$(window).scroll(function(){
  if($(window).scrollTop() < 100){
      $("#miniThisNav").fadeOut("fast");
  }
});

function scrollToTop(){
	$('html, body').animate({ scrollTop: 0 }, 'fast');
}