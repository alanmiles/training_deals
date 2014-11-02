jQuery ->
  $(document).on "click", "#businesses th a", ->
    $.getScript @href 
    false
  $("#businesses_search input").keyup ->
    $.get $("#businesses_search").attr("action"), $("#businesses_search").serialize(), null, "script"
    false
