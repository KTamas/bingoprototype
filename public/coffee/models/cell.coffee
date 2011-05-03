class Cell extends Backbone.Model
  initialize: ->
    @__defineGetter__ 'selected', -> @get 'selected'
    @__defineSetter__ 'selected', (value)-> @set selected:value
