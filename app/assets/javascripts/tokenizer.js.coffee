class window.Tokenizer

  el: null
  tokens: {}
  input: null
  container_width: 0
  container_max_width: 0
  list_width: 0
  tokens_list_left_offset: 0
  max_cid: 0

  constructor: (el) ->
    this.el = $(el)
    this.initialize()
    this.input = new TokenInput(this)

  initialize: ->
    _.bindAll(this, 'focus')
    this.el.bind('click', this.focus)
    $('.token-input input').hide()
    $("#tokenizer-placemark").show()
    this.container_max_width = parseInt(this.el.css('width')) - 150

  addToken: (text) ->
    token = new Token(text, this)
    this.tokens[token.cid] = token
    this.tokens_list().append(token.render().el)
    token.calculate_width()
    this.list_width_increased(token.width)
    this.input.el.val('')
    this.change()

  removeToken: (token) ->
    delete this.tokens[token.cid]
    this.change()

  get_next_cid: ->
    this.max_cid += 1

  find_by_cid: (cid) ->
    _.find(this.tokens, (token) -> token.cid = cid)

  focus: ->
    $("#tokenizer-placemark").hide()
    $('.token-input input').show()
    this.el.find('.token-input input').focus()

    # Это устраревший функционал, пока оставлю тут эту хрень "на память"
    #taglist.dropdown_pane.open()

  to_string: ->
    str = _.map(this.tokens, (token, key) -> token.text).join()
    if str.length == 0
      return null
    else
      return str

  change: ->
    Sale.appView.refreshList({tags: this.to_string()})

  # Вспомогательные методы
  tokens_list: ->
    this.el.find('.tokens-list-container .tokens-list')

  list_width_increased: (width) ->
    this.list_width += width

    if this.container_width + width >= this.container_max_width
      this.container_width = this.container_max_width
      this.tokens_list_left_offset = this.container_max_width - this.list_width
      if this.tokens_list_left_offset < 0
        this.el.find('.tokens-list-container .tokens-list').css('left', this.tokens_list_left_offset)
    else
      this.container_width += width

    this.el.find('.tokens-list-container').css('width', this.container_width)

  list_width_decreased: (width) ->
    this.list_width -= width

    if this.container_width + width >= this.container_max_width
      this.tokens_list_left_offset = this.container_max_width - this.list_width

      if this.list_width < this.container_max_width
        this.container_width = this.container_max_width - (this.container_max_width - this.list_width)

      if this.tokens_list_left_offset < 0
        this.el.find('.tokens-list-container .tokens-list').css('left', this.tokens_list_left_offset)
      else
        this.el.find('.tokens-list-container .tokens-list').css('left', 0)

    else if this.list_width < this.container_max_width
      this.container_width = this.container_max_width - (this.container_max_width - this.list_width)

    this.el.find('.tokens-list-container').css('width', this.container_width)


class Token
  el: null
  tagName: 'li'
  className: 'token-item'
  tokenizer: null
  template: "#token-item-template"
  text: null
  width: 0
  cid: null

  constructor: (text, tokenizer) ->
    this.text = text
    this.tokenizer = tokenizer
    this.cid = this.tokenizer.get_next_cid()

    this.el = $(document.createElement(this.tagName))
    this.el.addClass(this.className)

  initialize: ->
    _.bindAll(this, 'destroy', 'mouseout', 'mouseleave')

    this.el.find('.destroy').bind('click', this.destroy)
    this.el.bind('mouseout', this.mouseout)
    this.el.bind('mouseleave', this.mouseleave)

  render: ->
    template = _.template($(this.template).html())
    $(this.el).html(template({text: this.text}))
    this.initialize()
    this

  destroy: ->
    this.el.remove()
    this.tokenizer.removeToken(this)
    this.tokenizer.list_width_decreased(this.width)

  mouseout: ->
    this.el.addClass('highlighted')

  mouseleave: ->
    this.el.removeClass('highlighted')

  calculate_width: ->
    console.log('width ???')
    this.width += this.el.width()
    this.width += parseInt(this.el.css("margin-left")) + parseInt(this.el.css("margin-right"))

    #this.width += parseInt(this.el.css("border-width")) * 2
    console.log(this.width)
    this.width += parseInt(this.el.css("padding-left")) + parseInt(this.el.css("padding-right"))
    


class TokenInput
  el: null
  path: '.token-input input'
  resizer: null
  width: 200
  tokenizer: null

  constructor: (tokenizer) ->
    this.tokenizer = tokenizer
    this.el = $(this.path)
    this.resizer = $("#resizer")
    this.initialize()

  initialize: ->
    _.bindAll(this, 'resize', 'search_tags', 'next_suggestion', 'prev_suggestion', 'pick_suggestion')
    this.el.bind('keyup', @resize)
    this.el.bind('keyup', @search_tags)
    this.el.bind('keyup', @next_suggestion)
    this.el.bind('keyup', @prev_suggestion)
    this.el.bind('keyup', @pick_suggestion)

  resize: ->
    this.resizer.text(this.el.val())
    this.width = this.resizer.width()
    this.el.css('width', this.width)
    console.log("my width is #{this.width}")

  search_tags: (event) ->

    d_keycodes = [13, 38, 40]

    if event.keyCode in d_keycodes
      return false

    taglist.search(this.el.val())

  next_suggestion: (event) ->
    if event.keyCode == 40
      taglist.next_tag()

  prev_suggestion: (event) ->
    if event.keyCode == 38
      taglist.prev_tag()

  pick_suggestion: (event) ->
    if event.keyCode == 13
      taglist.pick_tag()
    


#####
#####

class window.Taglist

  container: null
  el: null
  tags: []
  url: '/tags?'

  constructor: (container) ->


    @container = $(container)
    @el = @container.find("ul")
    @current_tag_index = 0

    @is_active = false

    # Вроде как блок ниже уже морально устарел. Должна использоваться какая-то другая панелька
    #this.dropdown_pane = _.find(fc.filters, (filter) ->
    #    filter.rel == 'filter-input'
    #  ).pane

  initialize: ->
    _.bindAll(this, 'onkeypress')

    $("body").bind("keydown", @onkeypress)

    $(this).keypress(
      ->
        console.log('.......................')
    )

  addTag: (name) ->
    tag = new Tag(name, this)
    this.tags.push(tag)
    this.el.append(tag.render().el)


  removeTag: (name) ->

  clear: ->
    tag.destroy() for tag in this.tags
    this.tags = []


  search: (string) ->

    @show()

    console.log(">#{string}<")
    _this = this
    $.get(
      "#{this.url}s=#{string}",
      (data) ->
        _this.clear()
        _this.addTag(d.name) for d in data
        _this.selected_tag = 0
    )


  next_tag: ->
    console.log('try to select next tag!')
    if @current_tag_index < @tags.length
      @current_tag_index += 1
    else
      @current_tag_index = 0

    @select_current_tag()

  prev_tag: ->
    console.log('try to select prev tag!')
    if @current_tag_index > 0
      @current_tag_index -= 1
    else
      @current_tag_index = @tags.length - 1

    @select_current_tag()


  select_current_tag: ->
    if @get_selected_tag() != undefined
      @get_selected_tag().deselect()

    @tags[@current_tag_index].select()


  pick_tag: ->
    console.log('try to pick current tag!')
    @tags[@current_tag_index].pick()

  get_selected_tag: ->
    _.find(@tags, (tag) -> tag.selected == true)


  show: ->
    if @is_active == false
      @is_active = true
      @container.show()
      console.log('show container???')
      console.log(@container)

  hide: ->
    if @is_active == true
      @is_active = false
      @container.hide()

  onkeypress: ->
    console.log('some key pressed!!!')

class Tag

  el: null
  name: null
  taglist: null
  tagName: 'li'
  className: 'tag'


  constructor: (name, taglist) ->
    this.name = name
    this.taglist = taglist

    this.el = $(document.createElement(this.tagName))
    this.el.addClass(this.className)

    @selected = false

    this.initialize()

  initialize: ->
    _.bindAll(this, 'pick')

    this.el.bind('click', @pick)
    #$(this).bind('pick', @onpick)

  render: ->
    this.el.html(this.name)
    this


  select: ->
    @selected = true
    @el.addClass('selected')

  deselect: ->
    @selected = false
    @el.removeClass('selected')

  destroy: ->
    this.el.remove()

  pick: ->
    t.addToken(this.name)
    this.taglist.clear()
    this.taglist.hide()