$ ->
  $("#login-link").bind("click",
    ->
      show_login_modal()

      false
  )

  $(".oauth-link").bind("click",
    ->
      (window.open($(this).attr("href"), "vkontakte", "location,top=0")).focus()
      false
  )




window.show_login_modal = ->
  $("#login-modal-overlay").show()
  $("#login-modal-background").show()
  $("#login-modal").show()