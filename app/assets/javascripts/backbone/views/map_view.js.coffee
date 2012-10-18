class Sale.Views.MapView extends Backbone.View

  initialize: ->
    this.map = new ymaps.Map($("#map")[0], {center: [55.76, 37.64], zoom: 14})

    @clusterer = null

    this.map.behaviors.disable(['dblClickZoom', 'magnifier.rightButton'])
    this.map.controls.add('smallZoomControl', { left: 5, top: 75 })

    that = this
    this.map.events.add("boundschange", (that) =>
      Sale.appView.refreshList({bounds: this.map.getBounds()})
    )

    this


  addPlacemark: (place) ->

    balloonView = new Sale.Views.PlaceBalloon({model: place})

    myBalloonLayout = ymaps.templateLayoutFactory.createClass('$[properties.content]');
    ymaps.layout.storage.add('my#superlayout', myBalloonLayout);

    placemark = new ymaps.Placemark(
      place.latlng(),
      {
        content: balloonView.render().el
      },
      {  
        balloonAutoPan: false,
        hideIconOnBalloonOpen: false,
        balloonShadow: false,
        balloonLayout: "my#superlayout",
        iconImageHref: '/images/marker_empty.png',
        iconImageSize: [32, 32],
        iconImageOffset: [-20, -30]
      }
    )

    that = this

    placemark.events.add("click", (that) =>
      show_place_modal(place.get("id"))
    )

    placemark.events.add("mouseenter", (that) =>
      placemark.balloon.open()
    )

    placemark.events.add("mouseleave", (that) =>
      placemark.balloon.close()
    )

    placemark.events.add("balloonopen", (that) =>
      place.placemark.options.set("iconImageHref", "/images/marker_full.png")
    )

    placemark.events.add("balloonclose", (that) =>
      place.placemark.options.set("iconImageHref", "/images/marker_empty.png")
    )

    place.placemark = placemark

    console.log @map.getZoom()
    if @map.getZoom() >= 15
      @map.geoObjects.add(placemark)
    else
      @clusterer.add(placemark)
    
    @

  addPlacemarks: ->
    @clusterer = new ymaps.Clusterer({gridSize: 280})
    @addPlacemark(place) for place in Sale.places.models
    @map.geoObjects.add(@clusterer)
    @

