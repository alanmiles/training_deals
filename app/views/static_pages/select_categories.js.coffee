$("#cat_select").empty()
  .append("<%= escape_javascript(render(:partial => "categories/categories")) %>")