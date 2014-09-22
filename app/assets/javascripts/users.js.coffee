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

jQuery ($) ->
  $("#side-content-7").click ->
    $("#side-detail-7").toggle()
    if $('#ct-content-7').hasClass('down')
      $('#ct-content-7').addClass('up');
      $('#ct-content-7').removeClass('down')
    else
      $('#ct-content-7').addClass('down');
      $('#ct-content-7').removeClass('up')        

jQuery ($) ->
  $("#side-content-8").click ->
    $("#side-detail-8").toggle()
    if $('#ct-content-8').hasClass('down')
      $('#ct-content-8').addClass('up');
      $('#ct-content-8').removeClass('down')
    else
      $('#ct-content-8').addClass('down');
      $('#ct-content-8').removeClass('up')    

jQuery ($) ->
  $("#side-content-9").click ->
    $("#side-detail-9").toggle()
    if $('#ct-content-9').hasClass('down')
      $('#ct-content-9').addClass('up');
      $('#ct-content-9').removeClass('down')
    else
      $('#ct-content-9').addClass('down');
      $('#ct-content-9').removeClass('up') 

jQuery ($) ->
  $("#side-content-10").click ->
    $("#side-detail-10").toggle()
    if $('#ct-content-10').hasClass('down')
      $('#ct-content-10').addClass('up');
      $('#ct-content-10').removeClass('down')
    else
      $('#ct-content-10').addClass('down');
      $('#ct-content-10').removeClass('up')    

jQuery ->
  if document.getElementById("latitude") isnt null
    currentAddress = $("#loctn").val()
    if currentAddress is ""
        foundPlace = "Manchester, UK"
    else
        foundPlace = currentAddress
    storedLocation = foundPlace
    $("#map_updated").val("No")
    $("#geocomplete").geocomplete(
        map: ".map_canvas"
        location: foundPlace
        details: "form"
    ).bind("geocode:result", (event, result) ->
        $("#loctn_status").val("Pass")
        $(".map_canvas").show()
        newLocation = $("#geocomplete").val()
        if newLocation is storedLocation
          $("#map_updated").val("No")
        else
          $("#map_updated").val("Yes")
    ).bind("geocode:error", (event, status) ->
        $("#loctn_status").val("Fail")
        $(".map_canvas").hide()
        $("#map_updated").val("No")
        alert "ERROR: Google Maps does not recognize this location. Please try again."
    )

    $("#find").click ->
        $("#geocomplete").trigger "geocode"

    $("form").submit (event) ->
        finalLocation = $("#geocomplete").val()
        updateStatus = $("#map_updated").val()
        unless (finalLocation is storedLocation) or (updateStatus is "Yes")
          event.preventDefault()
          alert "There's a problem with your location. If the map is displayed, try clicking on the 'find' button, and the map should reset to your location. If it's not displayed, re-enter your location and click 'find'; if the location is a valid Google Maps reference, the map will be displayed. Then try creating your account again. If still unsuccessful, please read 'Page Guidance (Location)' on the left."
