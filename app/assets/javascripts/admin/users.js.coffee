jQuery ->
  $(document).on "click", "#users th a", ->
    $.getScript @href 
    false
  $("#users_search input").keyup ->
    $.get $("#users_search").attr("action"), $("#users_search").serialize(), null, "script"
    false 		
