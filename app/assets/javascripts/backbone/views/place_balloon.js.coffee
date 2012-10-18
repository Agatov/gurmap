class Sale.Views.PlaceBalloon extends Backbone.View

  render: ->
    template = _.template($("#place-balloon-template").html())
    $(this.el).html(template(this.model.toJSON()))
    this
