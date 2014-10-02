$("#topic_select").empty()
  .append("<%= escape_javascript(render(:partial => "topics/topics")) %>");
$(".display-total").html('<%= escape_javascript(render :partial => "total_category") %>');