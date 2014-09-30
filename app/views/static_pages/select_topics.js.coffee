$("#topic_select").empty()
  .append("<%= escape_javascript(render(:partial => "topics/topics")) %>")