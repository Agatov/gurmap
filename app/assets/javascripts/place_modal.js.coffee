$ ->

  class PlaceModalGallery


    el_class: "photo"

    constructor: ->
      @photos_count = $(".#{@el_class}").length
      @current = @photos_count
      $($(".#{@el_class}")[0]).show()

    show_prev: ->
      @hide_current()
      @dec_current()
      @show_current()
      
    show_next: ->
      @hide_current()
      @inc_current()
      @show_current()

    show_current: ->
      $($(".#{@el_class}")[@current - 1]).show()

    hide_current: ->
      $($(".#{@el_class}")[@current - 1]).hide()

    inc_current: ->
      unless @current == @photos_count
        @current += 1
      else
        @current = 1

    dec_current: ->
      unless @current == 1
        @current -= 1
      else
        @current = @photos_count



  window.show_place_modal = (id) ->
    $.get(
      "/places/#{id}/preview",
      (data) ->
        modal_window = $("#modal-window")
        modal_window .html(data)
        modal_window.css("top", ($(document).height() - modal_window.height()) / 2)
        modal_window.css("left", ($(document).width() - modal_window.width()) / 2)

        window.place_modal_gallery = new PlaceModalGallery()

        $(".photo").first().show()

        $("#modal-background").show()
        modal_window.show()

        window.po = new PlaceOrder(id)
    )

  window.close_place_modal = ->
    $("#modal-window").hide()
    $("#modal-background").hide()
    delete window.po
    $(".hours").html('')

  $("#close-place-window").live("click",
    ->
      close_place_modal()
  )

  $(".photo").live("click",
    ->
      console.log("trying show next photo")
      place_modal_gallery.show_next()
  )

  $("#modal-background").bind("click",
    ->
      close_place_modal()
  )