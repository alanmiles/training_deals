$ ->
	$(".pagination a").click ->
		$.get @href, null, null, "script"
		false

$ ->
	$(document).on 'change', '#method-filter', (evt) ->
		newMethod = $("#method-filter option:selected").text()
		$.ajax 'filter_by_method',
			type: 'GET'
			dataType: 'script'
			data: {
				method_id: $("#method-filter option:selected").val()
			}
		$(".pagination a").click ->
			$.get @href, null, null, "script"
			false	

#    error: (jqXHR, textStatus, errorThrown) ->
#        console.log("AJAX Error: #{textStatus}")
#     
#    success: (data, textStatus, jqXHR) ->
#        console.log("Dynamic category select OK!")