class CellView extends Backbone.View
  className: 'cell'
  events:
    'click': 'click'
  initialize: ->
    @model.bind 'change:selected', @toggle_selected
    @model.bind 'change:winning', @toggle_winning
  render: ->
    $(@el).html @model.get 'value'
    $(@el).addClass 'selected' if @model.selected
    return this
  click: ->
    @model.set selected: !@model.selected
  toggle_selected: =>
    @collection.look_for_matches()
    if @model.selected
      $(@el).addClass 'selected'
    else
      $(@el).removeClass 'selected'
  toggle_winning: =>
    if @model.get 'winning'
      $(@el).addClass 'winning'
    else
      $(@el).removeClass 'winning'
