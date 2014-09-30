$ ->
	$(document).on 'change', '#genre_select', (evt) ->
		newGenre = $("#genre_select option:selected").text()
		if newGenre == "Please select"
			$("#cat_select").empty()
			$("#topic_select").empty()
			$(".hidden-content").hide()
			$(".hidden-content-2").hide()
		else
		    $.ajax 'select_categories',
		      type: 'GET'
		      dataType: 'script'
		      data: {
		        genre_id: $("#genre_select option:selected").val()
		      }
		    $(".hidden-content").show()
			$(".hidden-content-2").hide()
		
    error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
     
    success: (data, textStatus, jqXHR) ->
        console.log("Dynamic category select OK!")

$ ->
	$(document).on 'change', '#cat_select', (event) ->
		newCat = $("#cat_select option:selected").text()
		if newCat == "Select a category"
			$("#topic_select").empty()
			$(".hidden-content-2").hide()
		else
		    $.ajax 'select_topics',
		      type: 'GET'
		      dataType: 'script'
		      data: {
		        category_id: $("#cat_select option:selected").val()
		      } 
		    $(".hidden-content-2").show() 

    error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
     
    success: (data, textStatus, jqXHR) ->
        console.log("Dynamic category select OK!")