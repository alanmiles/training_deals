jQuery ($) ->
	$(".html-content").hide()
	$(".js-content").show()

jQuery ->
	categories = $('#topic_category_id').html()
	topics = $('#product_topic_id').html()
	$('#genre_genre_id').change ->
		genre = $('#genre_genre_id :selected').text()
		cat_options = $(categories).filter("optgroup[label='#{genre}']").html()
		if cat_options
			$('#topic_category_id').html(cat_options)
			category = $('#topic_category_id :selected').text()
			topic_options = $(topics).filter("optgroup[label='#{category}']").html()
			if topic_options
				$('#product_topic_id').html(topic_options)
			else
				$('#product_topic_id').empty()
		else
			$('#topic_category_id').empty()
			$('#product_topic_id').empty()


jQuery ->
	topics = $('#product_topic_id').html()
	$('#topic_category_id').change ->
		category = $('#topic_category_id :selected').text()
		topic_options = $(topics).filter("optgroup[label='#{category}']").html()
		if topic_options
			$('#product_topic_id').html(topic_options)
		else
			$('#product_topic_id').empty()