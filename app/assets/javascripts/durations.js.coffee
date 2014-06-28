jQuery ($) ->
	$('#durations').sortable(
		axis: 'y'
		handle: '.glyphicon-sort'
		update: ->
			$.post($(this).data('update-url'), $(this).sortable('serialize'))
	)