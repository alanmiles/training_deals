$("#cat_select").empty()
  .append("<%= escape_javascript(render(:partial => "categories/categories")) %>");
$(".display-total").html('<%= escape_javascript(render :partial => "total_genre") %>');