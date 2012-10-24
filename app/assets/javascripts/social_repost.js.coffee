class window.SocialRepost

  template_id = "social-repost-widget"

  constructor: (container, url) ->
    @el = container
    @template = $("##{template_id}")
    @url = url

  initialize: ->

  render: ->
    template = _.template($(@template).html())
    @el.html(template({url: @url}))
    @