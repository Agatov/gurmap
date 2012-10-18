class Sale.Collections.PlaceList extends Backbone.Collection

  model: Sale.Models.Place

  url_string: null

  params: {
    bounds: null,
    tags: null,
    sale: null,
    min_check: null,
    max_check: null
  }

  @bounds = false

  update_params: (params) ->
    _.each(params, (value, key) ->
      this.change_parameter(key, value)
    , this)

  change_parameter: (parameter, value) ->

    if this.params[parameter] or this.params[parameter] == null
      this.params[parameter] = value
    else
      console.log("wrong parameter name: #{parameter}")

  # Все параметры null
  is_params_empty: ->
    _.all(_.values(this.params), (param) ->
      param == null
    )
  
  generate_url: ->
    this.url_string = '/places.json'
    unless this.is_params_empty()

      q = []

      if this.params['bounds'] != null
        q.push "top=#{this.params.bounds[0].toString()}"
        q.push "bottom=#{this.params.bounds[1].toString()}"

      if this.params['tags'] != null
        q.push "tags=#{this.params.tags}"

      if this.params['min_check'] != null
        q.push "check=#{this.params.min_check},#{this.params.max_check}"

      if this.params['sale'] != null
        q.push "sale=#{this.params.sale}"

      this.url_string += "?#{q.join('&')}"

    this

  url: ->
    this.generate_url().url_string
