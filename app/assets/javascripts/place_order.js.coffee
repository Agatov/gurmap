class window.PlaceOrder

  constructor: (place_id) ->
    @persons_number = null
    @datetime = null
    @place_id = place_id

    @initialize()
    

  initialize: ->
    @persons_number = 2

    @datepicker = new OrderDatepicker("#order-form-datepicker", @place_id)
    @personspicker = new Numberpicker("#persons-number-picker", @persons_number )
    @submit_el = $("#order-form-submit")

    _.bindAll(@, 'datetime_changed', 'persons_number_changed', 'show_submit', 'make_order', 'create_order')

    $(@datepicker).bind('value_changed', @datetime_changed)
    $(@datepicker).bind('value_changed', @show_submit)

    $(@personspicker).bind('value_changed', @persons_number_changed)
    $(@personspicker).bind('value_changed', @show_submit)

    $("#pre-order .button").bind('click', @make_order)

    @submit_el.bind('click', @create_order)

  datetime_changed: ->
    @datetime = @datepicker.get_value()
    console.log("datetime changed to #{@datetime}")

  persons_number_changed: ->
    @persons_number = @personspicker.value
    console.log("persons number changed to #{@persons_number}")

  show_submit: ->
    if @datetime and @persons_number
      @submit_el.show()

  hide_submit: ->
    @submit_el.hide()

  make_order: ->
    $("#pre-order").hide()
    $("#order-form").show()

  create_order: ->
    console.log('creating order')
    $("#order-form").remove()
    $("#order-ready").show()

    $.post(
      '/orders',
      {
        "order[place_id]": @place_id,
        "order[date]": @datitime,
        "order[persons_number]": @persons_number
      }
      (data) ->
        if data.status == 'ok'

          # виджет "рассказать"
          window.social_repost_widget = new SocialRepost($("#order-ready .social"), data.vk_social_url)
          social_repost_widget.render()

          # Начинаем чекать.
          window.order_checker = new OrderChecker($("#order-checker"), data.order_id)

          console.log(data)
        else
          console.log('order error')

    )


$ ->
  if $("#place").length > 0
    window.po = new PlaceOrder($("#place").attr("place_id"))
