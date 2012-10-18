class Sale.Models.Place extends Backbone.Model

  defaults: {
    is_picked: false
  }

  url: ->
    '/places/' + this.get("id")

  latlng: ->
    [this.get("latitude"), this.get("longitude")]

  highlight: ->
    this.set("is_picked", true)

    #this.placemark.options.set("iconImageHref", "/images/marker_full.png")