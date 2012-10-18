window.show_about_modal = ->
  modal_window = $("#about-modal")
  modal_window.css("top", ($(document).height() - modal_window.height()) / 2)
  modal_window.css("left", ($(document).width() - modal_window.width()) / 2)
  $("#about-modal-background").show()
  modal_window.show()

window.close_about_modal = ->
  $("#about-modal").hide()
  $("#about-modal-background").hide()

$ ->
  show_about_modal()

  $("#close-about-modal").bind("click",
    ->
      close_about_modal()
  )