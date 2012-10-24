class window.OrderChecker

  interval: 3

  constructor: (container, order_id) ->
    @id = order_id
    @valid = false
    @interval_id = null
    @checks_num = 0

    @view = new OrderCheckerView(container)

    @el =

    @initialize()


  initialize: ->
    @view.initialize()
    @start()

  start: ->
    _this = @
    @interval_id = setInterval(
      ->
        _this.check()
      @interval * 1000)

  stop: ->
    clearInterval(@interval_id)
    @checks_num = 0

  check_url: ->
    "/orders/{@id}/check"

  check: ->

    @checks_num += 1
    console.log("checking... (#{@checks_num})")

    _this = @

    $.get(
      @check_url,
      (data) ->
        if data.status == 'success'

          _this.stop())
          _this.view.show_checked()
        else if data.status == 'error'
          # Продолжаем, хуле
        else
          _this.stop()
          _this.view.show_error()
    )


class window.OrderCheckerView

  constructor: (container) ->

    @el = container

    @checking_screen = @el.find(".checking")
    @checked_screen = @el.find(".checked")
    @check_error_screen = @el.find(".check-error")


  initialize: ->
    @checking_screen.show()


  show_checking: ->
    @checking_screen.show()

  show_checked: ->
    @checking_screen.hide()
    @checked_screen.show()

  show_error: ->



