class Sale.Views.AppView extends Backbone.View
  el: $("#main")

  addOne: (place) ->
    view = new Sale.Views.PlaceView({model: place})
    $("#places-list").append(view.render().el)

  addAll: ->
    $("#places-found").text(Sale.places.models.length)
    this.addOne(place) for place in Sale.places.models

  scrollTo: (place) ->
    scroll_amount = $("#places-list").scrollTop()
    element_top = $("li[cid=#{place.cid}]").offset().top
    $("#places-list").animate({scrollTop: scroll_amount + element_top - 80}, 'slow')
    this

  refreshList: (options) ->
    Sale.places.update_params(options)

    Sale.mapView.map.geoObjects.each((e) =>
      Sale.mapView.map.geoObjects.remove(e)
    )

    Sale.places.reset()
    
    Sale.places.fetch({
      success: ->
        Sale.mapView.addPlacemarks()
        Sale.appView.addAll()
    })