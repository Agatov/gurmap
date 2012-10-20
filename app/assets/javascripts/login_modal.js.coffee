class window.LoginModal

  constructor: ->
    @user_id = null
    @user_info = null
    @closed = true

    @overlay = $("#login-modal-overlay")
    @background = $("#login-modal-background")
    @phone_form = $("#phone-form")
    @phone_submit = $("#phone-submit-button")
    @el = $("#login-modal")

    @hello_screen = $("#login-modal .hello")
    @phone_request_screen = $("#login-modal .phone-request")
    @phone_confirm_screen = $("#login-modal .phone-confirm")

    @initialize()


  initialize: ->

    _.bindAll(@, "show", "hide", "submit_phone")

    #@background.bind("click", @hide)
    @phone_submit.bind("click", @submit_phone)

    @hello_screen.show()


  show: ->
    @overlay.show()
    @background.show()
    @el.show()

    @closed = false

  hide: ->
    @el.hide()
    @background.hide()
    @overlay.hide()

    @closed = true


  get_user: (user_id) ->
    $.get(
      "/users/#{user_id}/info.json",
      (data) ->
        @user_info = data
    )

  submit_phone: ->
    _this = @
    $.post(
      @phone_form.attr("action"),
      @phone_form.serialize(),
      (data) ->

        # Все отлично, выводим поле для проверки телефона
        if data.status == 'ok'
          #alert("Ololo, u are lucky ass!")
          _this.display_phone_confirm_screen()
        # Телефон введен неправильно
        else if data.status == 'bad_phone'

        # Произошла ебаная хуйня
        else

    )

  check_phone: ->
    $


  # States

  display_phone_request_screen: ->
    @hello_screen.hide()
    @phone_request_screen.show()

  display_phone_confirm_screen: ->
    @phone_request_screen.hide()
    @phone_confirm_screen.show()







