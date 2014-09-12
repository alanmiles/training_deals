jQuery ($) ->
	$(".html-menu").hide()
	$(".js-menu").show() 

jQuery ($) ->
  $(".toggler-1").click ->
    $(".explanation").toggle()
    if $('#ct-toggler-1').hasClass('down')
      $('#ct-toggler-1').addClass('up');
      $('#ct-toggler-1').removeClass('down')
    else
      $('#ct-toggler-1').addClass('down')
      $('#ct-toggler-1').removeClass('up')

jQuery ($) ->
  $("#user-id").click ->
    $("#ct-menu").addClass "down"
    $("#ct-menu").removeClass "up"
    if $('#ct-header').hasClass('down')
      $('#ct-header').addClass('up');
      $('#ct-header').removeClass('down')
    else
      $('#ct-header').removeClass('up')
      $('#ct-header').addClass('down')

jQuery ($) ->
  $('.toggler-menu').click ->
    $("#ct-header").addClass "down"
    $("#ct-header").removeClass "up"
    if $('#ct-menu').hasClass('down')
      $('#ct-menu').addClass('up');
      $('#ct-menu').removeClass('down')
    else
      $('#ct-menu').removeClass('up')
      $('#ct-menu').addClass('down')

jQuery ->
  $(document).click ->
    unless $("#menu-items").is ":focus"
        $('#ct-menu').addClass('down')
        $('#ct-menu').removeClass('up')

    unless $("#fat-menu").is ":focus"
        $('#ct-header').addClass('down')
        $('#ct-header').removeClass('up')
    
jQuery ($) ->
  $(".toggler-2").click ->
    $(".explanation-2").toggle()
    if $('#ct-toggler-2').hasClass('down')
      $('#ct-toggler-2').addClass('up');
      $('#ct-toggler-2').removeClass('down')
    else
      $('#ct-toggler-2').addClass('down');
      $('#ct-toggler-2').removeClass('up')

jQuery ($) ->
  $("#side-content-1").click ->
    $("#side-detail-1").toggle()
    if $('#ct-content-1').hasClass('down')
      $('#ct-content-1').addClass('up');
      $('#ct-content-1').removeClass('down')
    else
      $('#ct-content-1').addClass('down');
      $('#ct-content-1').removeClass('up')

jQuery ($) ->
  $("#side-content-2").click ->
    $("#side-detail-2").toggle()
    if $('#ct-content-2').hasClass('down')
      $('#ct-content-2').addClass('up');
      $('#ct-content-2').removeClass('down')
    else
      $('#ct-content-2').addClass('down');
      $('#ct-content-2').removeClass('up')

jQuery ($) ->
  $("#side-content-3").click ->
    $("#side-detail-3").toggle()
    if $('#ct-content-3').hasClass('down')
      $('#ct-content-3').addClass('up');
      $('#ct-content-3').removeClass('down')
    else
      $('#ct-content-3').addClass('down');
      $('#ct-content-3').removeClass('up')

jQuery ($) ->
  $("#side-content-4").click ->
    $("#side-detail-4").toggle()
    if $('#ct-content-4').hasClass('down')
      $('#ct-content-4').addClass('up');
      $('#ct-content-4').removeClass('down')
    else
      $('#ct-content-4').addClass('down');
      $('#ct-content-4').removeClass('up')

jQuery ($) ->
  $("#side-content-5").click ->
    $("#side-detail-5").toggle()
    if $('#ct-content-5').hasClass('down')
      $('#ct-content-5').addClass('up');
      $('#ct-content-5').removeClass('down')
    else
      $('#ct-content-5').addClass('down');
      $('#ct-content-5').removeClass('up') 

jQuery ($) ->
  $("#side-content-6").click ->
    $("#side-detail-6").toggle()
    if $('#ct-content-6').hasClass('down')
      $('#ct-content-6').addClass('up');
      $('#ct-content-6').removeClass('down')
    else
      $('#ct-content-6').addClass('down');
      $('#ct-content-6').removeClass('up')       

jQuery ->
	if document.getElementById("user_latitude") isnt null
    	latitude = document.getElementById("user_latitude")
    	longitude = document.getElementById("user_longitude")
    	if latitude.value is ""
      		coords = [
        		53.47213
        		-2.2972999
      		]
    	else
      		coordinates = [
        		latitude.value
        		longitude.value
      		]
      		coords = coordinates.join(", ")
		$("#geocomplete").geocomplete
  			map: ".map_canvas"
  			location: coords
  			details: "form"

		$("#find").click ->
  			$("#geocomplete").trigger "geocode"			

      		
  		