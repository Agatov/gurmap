#= require_self
# require_tree ./templates
#= require_tree ./models
#= require_tree ./views
# require_tree ./routers

window.Sale =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ->
    this.places = new Sale.Collections.PlaceList()
    this.appView = new Sale.Views.AppView()
    this.mapView = new Sale.Views.MapView()


    this.places.fetch({
      success: ->
        Sale.appView.addAll()
        Sale.mapView.addPlacemarks()
      })