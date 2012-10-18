class window.Numberpicker

  el: null
  value_el: null
  increase_el: null
  descrease_el: null
  value: null

  constructor: (el, value) ->
    @el = $(el)

    @el.html($("#order-persons-picker-template").html())

    @value_el = @el.find(".value")
    @increase_el = @el.find(".increase")
    @decrease_el = @el.find(".decrease")
    @value = value

    @initialize()

  initialize: ->
    _.bindAll(@, 'increase', 'decrease')

    @increase_el.bind('click', @increase)
    @decrease_el.bind('click', @decrease)

    @render()

  render: ->
    $(@).trigger("value_changed")
    @value_el.text(@value)

  increase: ->
    @value += 1
    @render()

  decrease: ->
    if @value > 1
      @value -= 1
      @render()


$ ->
  #window.np = new NumberPicker("#persons-number-picker", 2)
  #console.log('asdasd')