class SheetView extends Backbone.View
  el: $("#sheet")
  initialize: ->
    @collection.bind 'refresh', @render
  render: =>
    @collection.each(@add_one)
  add_one: (cell) =>
    one = new CellView model:cell, collection: @collection
    @el.append one.render().el
