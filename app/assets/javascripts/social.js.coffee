$ ->

  $(".social-share").live("click",
    ->
      popup = window.open($(this).attr("href"), "agwindow", "width=600,height=300")
      popup.focus()
      false
  )