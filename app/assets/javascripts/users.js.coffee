jQuery ($) ->
	$(".html-menu").hide()
	$(".js-menu").show() 

$(document).ready ->
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
      		details: "form"
      		location: coords
      		mapOptions:
        		zoom: 10

