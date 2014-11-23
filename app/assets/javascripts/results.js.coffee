#$ ->
#  $(".paginator a").on "click", ->
#    $.getScript @href
#    false

$ ->
	$(document).on 'change', '#method-filter', () ->
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
	$(document).on 'change', '#location_id', () ->
		$.ajax 'filter_by_location',
			type: 'GET'
			dataType: 'script'
			data: {
				loc_id: $("#location_id option:selected").text()
			}

$ ->
	$(document).on 'change', '#price_id', () ->
		$.ajax 'filter_by_price',
			type: 'GET'
			dataType: 'script'
			data: {
				prc_id: $("#price_id option:selected").val()
			}

$ ->
	$("#qual_filter").keyup ->
		$.ajax 'filter_by_qualification',
			type: 'GET'
			dataType: 'script'
			data: {
				qualification_string: $("#qual_filter").val()
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

$ ->
	$(document).on 'change', '#arrange_id', () ->
		$.ajax 'sort_by_arrangement',
			type: 'GET'
			dataType: 'script'
			data: {
				arr_id: $("#arrange_id option:selected").val()
			}

#    error: (jqXHR, textStatus, errorThrown) ->
#        console.log("AJAX Error: #{textStatus}")
#     
#    success: (data, textStatus, jqXHR) ->
#        console.log("Dynamic category select OK!")