class Sale.Views.PlaceView extends Backbone.View

  tagName: 'tr'

  initialize: ->
    _.bindAll(this, 'render', 'highlight', 'remove');
    this.model.on('change:is_picked', this.highlight)
    Sale.places.on("reset", this.remove)

  render: ->
    template = _.template($("#place-list-item-template").html())
    $(this.el).attr('cid', this.model.cid)
    $(this.el).html(template(this.model.toJSON()))
    $(this.el).find("a").attr("href", this.model.url())
    this

  events: {
    "mouseenter" : "mouseenter",
    "mouseleave" : "mouseleave",
    "click" : "click"
    "click .place-name" : "show_modal"
  }


  show_modal: ->
    show_place_modal(@model.get("id"))
    return false

  click: ->
    if this.model.placemark
      this.model.placemark.balloon.open()

  mouseenter: ->
    if this.model.placemark
      this.model.placemark.balloon.open()

  mouseleave: ->
    if this.model.placemark
      this.model.placemark.balloon.close()

  highlight: ->
    if this.model.get("is_picked")
      $(this.el).addClass("picked")
    else
      $(this.el).removeClass("picked")