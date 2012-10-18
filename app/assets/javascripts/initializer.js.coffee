$ ->
  $(document).ready(
    ->

      $(".places-list-sort").bind("click",
        ->
          sort_by = $(this).attr("by")
          console.log("sorting by #{$(this).attr("by")}")
          Sale.places.comparator = (model) ->
            model.get(sort_by)

          Sale.places.sort()
          Sale.appView.addAll(Sale.places.models)
      )

      $("#results-tiny").toggle(
        ->
          $("#results-full").show("blind")
          $("#results-tiny").animate({
            top: "+=420px"
          })
        ->
          $("#results-full").hide("blind")
          $("#results-tiny").animate({
            top: "-=420px"
          })
      )

      $(window).resize(
        ->
          size_me()
      )

      #$("#reg-auth-modal").modal()

      $('#reg-auth').bind('click',
        ->
          console.log('asdasdasdasd')
          $("#reg-auth-modal").modal("show")

          return false
      )

      $("#slides").slides({
        preload: true,
        preloadImage: 'img/loading.gif',
        play: 5000,
        pause: 2500,
        hoverPause: true,
        paginationClass: 'slides-pagination',
        bigTarget: true
      })

      

      $("#slider-average-check").slider({
        range: true,
        min: 500,
        max: 10000,
        step: 250,
        values: [ 500, 10000 ],
        slide: (event, ui) ->
          $("#filter-average-check .content").text("#{ui.values[0]}R - #{ui.values[1]}R")
        change: (event, ui) ->
          $("#average-check-value").text("[#{ui.values[0]}R - #{ui.values[1]}R]")
          Sale.appView.refreshList({min_check: ui.values[0], max_check: ui.values[1]})
      });

      $("#slider-sale").slider({
        min: 10,
        max: 55,
        step: 5,
        value: 30,
        slide: (event, ui) ->
          $("#filter-sale .content").text("от #{ui.value}%")
        change: (event, ui) ->
          $("#sale-value").text("(от #{ui.value}%)")
          Sale.appView.refreshList({sale: ui.value})
      });

      waitForMap(
        ->
          size_me()
          
          Sale.init()

          window.fc = new FilterCollection()
          window.fc.initialize()

          window.t = new Tokenizer("ul.tokenizer")
          window.taglist = new Taglist('#suggestions')

          $("#tokenizer-examples .example").bind("click"
            ->
              t.addToken($(this).text())
          )

      )
  )


  window.waitForMap = (callback) ->
    if ymaps.Map
      callback(this)
    else
      setTimeout(
        ->
          waitForMap(callback)
        500
      )

  window.size_me = ->
    $("#map").css("height", $(window).height() - 100)

  
     


      