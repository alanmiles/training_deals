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
#		$(".pagination a").click ->
#			$.get @href, null, null, "script"
#			false

$ ->
	$("#q_filter").keyup ->
		$.ajax 'filter_by_qualification',
			type: 'GET'
			dataType: 'script'
			data: {
				qualification_string: $("#q_filter").val()
			}

$ ->
	$("#supply_filter").keyup ->
		$.ajax 'filter_by_supplier',
			type: 'GET'
			dataType: 'script'
			data: {
				supplier_string: $("#supply_filter").val()
			}

$ ->
	$("#kword_filter").keyup ->
		$.ajax 'filter_by_keyword',
			type: 'GET'
			dataType: 'script'
			data: {
				keyword_string: $("#kword_filter").val()
			}	

#    error: (jqXHR, textStatus, errorThrown) ->
#        console.log("AJAX Error: #{textStatus}")
#     
#    success: (data, textStatus, jqXHR) ->
#        console.log("Dynamic category select OK!")