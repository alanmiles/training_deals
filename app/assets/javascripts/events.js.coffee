jQuery ->
	$('#event_start_date').datepicker
		dateFormat: 'yy-mm-dd'

jQuery ->
	$('#event_end_date').datepicker
		dateFormat: 'yy-mm-dd'	

jQuery ($) ->
	$(".js-toggle-detail").show()
	$(".js-toggle-detail-2").show()

jQuery ($) ->
	handle = $(".js-toggle-detail").text()
	$(".js-toggle-detail").click ->
  	$(".js-more-detail").toggle()
  	if handle == "(more..)"	
  		$(".js-toggle-detail").text("(less..)")
  		handle = "(less..)"
  	else
  		$(".js-toggle-detail").text("(more..)")
  		handle = "(more..)"

jQuery ($) ->
	handle_2 = $(".js-toggle-detail-2").text()
	$(".js-toggle-detail-2").click ->
  	$(".js-more-detail-2").toggle()
  	if handle_2 == "(more..)"	
  		$(".js-toggle-detail-2").text("(less..)")
  		handle_2 = "(less..)"
  	else
  		$(".js-toggle-detail-2").text("(more..)")
  		handle_2 = "(more..)"	

jQuery ->
  #Ajax sorting and pagination on click
  $('#events td.sortable a, #events .pagination a').on('click', ->
    $.getScript(this.href)
    false
  )
  #Ajax search on submit
  $('#events_search').submit( ->
    $.get(this.action, $(this).serialize(), null, 'script')
    false
  )
  #Ajax search on keyup
  $('#events_search input').keyup( ->
    $.get($("#events_search").attr("action"), $("#events_search").serialize(), null, 'script')
    false
  )
