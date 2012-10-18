class window.OrderDatepicker

  el: null
  header_el: null
  days: []
  place_id: null
  date: null
  #active_day: null

  constructor: (el, place_id) ->
    console.log(place_id)
    @el = $(el)
    @el.html($("#order-date-picker-template").html())
    @header_el = @el.find(".header")

    @place_id = place_id
    @active_day = null
    @days = []
    @date = null
    @initialize()

  initialize: ->

    console.log('initializing')

    _this = @
    $.get(
      "/places/#{@place_id}/schedule",
      (days) ->
        _this.add_day(day) for day in days
        _this.days[0].activate()
    )

    _.bindAll(@, "choose_date", "cancel_date")

    @header_el.bind('click', @cancel_date)


  add_day: (data) ->
    day = new Day(data, @)
    @days.push day
    $(".days").append(day.render().el)

  find_active_day: ->
    _.find(@days, (day) -> day.is_active == true)

  get_value: ->
    if @active_day and @active_day.active_hour
      return "#{@active_day.value} #{@active_day.active_hour.value}"

    false

  get_nice_value: ->
    if @get_value()
      return "#{@active_day.date} #{@active_day.active_hour.value}"

  choose_date: ->
    @header_el.text(@get_nice_value())
    $(child).hide() for child in @el.children()
    @header_el.show()

    $(@).trigger('value_changed')

  cancel_date: ->
    $(child).show() for child in @el.children()
    @header_el.hide()

class Day

  el: null
  datepicker: null
  name: null
  date: null
  value: null
  active_hour: null

  template: '#day-template'
  tagName: 'div'
  tagClass: 'day'

  constructor: (data, datepicker) ->
    @datepicker = datepicker
    @name = data.dayname
    @date = data.datename
    @value = data.value
    @hours = []
    @active_hour = false
    @is_active = false

    @el = $(document.createElement(@tagName))
    @el.addClass(@tagClass)

    @initialize(data.hours)

  initialize: (hours) ->
    
    @add_hour(hour) for hour in hours

    _.bindAll(@, "pick")

    @el.bind("click", @pick)

  add_hour: (hour) ->
    hour = new Hour(hour, @)
    @hours.push hour

  render: ->
    template = _.template($(@template).html())
    @el.html(template({wday: @name, date: @date}))
    @

  pick: ->
    @datepicker.find_active_day().deactivate()
    @activate()

  activate: ->
    console.log('acitivating day')
    console.log(@is_active)
    @is_active = true
    console.log(@is_active)
    @el.addClass('active') 
    @datepicker.active_day = @
    $(".hours").append(hour.render().el) for hour in @hours
    height = Math.ceil(@hours.length / 5) * 50
    $(".hours").css("height", height)



  deactivate: ->
    @is_active = false
    @el.removeClass('active')

    if @active_hour
      @active_hour.deactivate()
      

    $(".hours").html('')
    $("#order-form-next-step").hide()

  find_active_hour: ->
    _.find(@hours, (hour) -> hour.is_active == true)

class Hour

  el: null
  day: null
  value: null
  is_active: false

  tagName: 'div'
  tagClass: 'hour'
  template: '#hour-template'


  constructor: (hour, day) ->
    @day = day
    @data = hour
    @value = hour.hour
    @sale = hour.sale

    @el = $(document.createElement(@tagName))
    @el.addClass(@tagClass)

  render: ->
    _.bindAll(@, 'pick')

    @el.bind('click', @pick)

    template = _.template($(@template).html())
    @el.html(template(@data))
    @

  pick: ->
    console.log('asd')
    if @day.active_hour
      @day.active_hour.deactivate()
    
    @activate()


  activate: ->
    @is_active = true
    @el.addClass('active')
    @day.active_hour = @

    # Когда выбрана дата, сворачиваем дейтпикер
    @day.datepicker.choose_date()
    
  deactivate: ->
    @is_active = false
    @el.removeClass('active')
  