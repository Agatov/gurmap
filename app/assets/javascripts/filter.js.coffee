class window.FilterCollection
  filters: []
  rel_to_filter: {}

  initialize: ->
    this.add_filter(f) for f in $(".dropdown")

  add_filter: (f) ->
    filter = new Filter(f, this)
    this.rel_to_filter[$(f).attr('rel')] = filter
    this.filters.push(filter)

  close_all_panes: ->
    f.pane.close() for f in this.filters

  get_filter_by_rel: (rel) ->
    this.rel_to_filter[rel]

class Filter
  el: null
  pane: null
  collection: null
  is_mouseover: false
  rel: null
  blocked: null

  constructor: (f, collection) ->
    this.el = $(f)
    this.collection = collection
    this.rel = this.el.attr('rel')
    this.blocked = this.el.hasClass('blocked')

    this.pane = new Pane($("##{this.rel}"), this)

    unless this.blocked
      _this = this

      this.el.bind("click",
        ->
          unless _this.pane.is_opened
            _this.collection.close_all_panes()

          _this.pane.toggle()
      )

      this.el.bind("mouseover", ->
        _this.is_mouseover = true
      )

      this.el.bind("mouseout", ->
        _this.is_mouseover = false
        _this.pane.close_with_delay()
      )

  change: (value) ->
    this.value = value
    

class Pane
  el: null
  filter: null
  is_opened: false
  is_mouseover: false
  delta: 0

  constructor: (f, filter) ->
    this.el = f
    this.filter = filter

    this.el.css("top", $("#filter").offset().top)
    #this.el.css("top", this.filter.el.offset().top)
    this.el.css("left", this.filter.el.offset().left)
    this.delta = $("#filter").height()

    unless this.filter.blocked
      _this = this

      this.el.bind("mouseover", (e) ->
        _this.is_mouseover = true
      )

      this.el.bind("mouseout", (e) ->
        _this.is_mouseover = false
        _this.close_with_delay()
      )

  toggle: ->
    console.log(this.is_opened)
    unless this.is_opened
      this.open()
    else
      this.close()

  open: ->
    unless this.is_opened
      this.is_opened = true
      this.filter.el.addClass('active')
      this.display_pane_open()

  close: ->
    if this.is_opened
      this.is_opened = false
      this.filter.el.removeClass('active')
      this.display_pane_hide()

  close_with_delay: ->
    _this = this
    setTimeout((e) ->
      if _this.can_close()
        _this.close()
    2000
    )

  can_close: ->
    unless this.is_mouseover or this.filter.is_mouseover
      if this.is_opened
        return true
      else
        return false
    else
      false

  display_pane_open: ->
    this.el.css("opacity", 0.1)
    this.el.show()

    this.el.animate({
      top: "+=#{this.delta}",
      opacity: '1'
    },100)


  display_pane_hide: ->
    _this = this

    this.el.animate({
      top: "-=#{this.delta}",
      opacity: '0.1'
    },
    100,
      ->
        _this.el.hide()      
    )