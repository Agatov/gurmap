$ ->

  if $("#oauth-success")
    _oauth = $("#oauth-success")
    if $.trim(_oauth.text()) == 'true'
      if window.opener
        if _oauth.attr("new_user") == 'true'
          window.opener.login_modal.display_phone_request_screen()
        else
          window.opener.logon_modal.hide()
          #window.opener.reload()

    window.close()




  $(".login-link").live("click",
    ->

      if $(this).hasClass("from-place-modal")
        close_place_modal()

      login_modal.show()
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