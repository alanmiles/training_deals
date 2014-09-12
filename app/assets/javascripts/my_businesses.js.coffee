jQuery ($) ->
	$(".html-guidance").hide()
	$(".js-guidance").show()

jQuery ($) ->
	$(".toggler").click ->
  		$(".explanation").toggle()
  		if $('#ct-toggler-1').hasClass('down')
      		$('#ct-toggler-1').addClass('up');
      		$('#ct-toggler-1').removeClass('down')
    	else
      		$('#ct-toggler-1').addClass('down');
      		$('#ct-toggler-1').removeClass('up')
  	

