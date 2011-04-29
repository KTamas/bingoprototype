$(document).ready ->
  class Cell extends Backbone.Model
    initialize: ->
      @__defineGetter__ 'selected', -> @get 'selected'
      @__defineSetter__ 'selected', (value)-> @set selected:value


  class Sheet extends Backbone.Collection
    initialize: ->
      @__defineGetter__ 'size', -> Math.sqrt @length

    model: Cell
    url: '/wordlist'


    every_nth: (n, offset=0, smallest=0, largest=@length) ->
      @select (cell) =>
        (@indexOf cell) % n == offset && (@indexOf cell) >=smallest && (@indexOf cell) <= largest

    check_match: (cells) ->
      if (_.pluck(cells, 'selected').reduce (p,c) -> p && c)
        _.each cells, (cell) -> cell.set winning:true
        return cells

    row_matches: ->
      results = for row in [0...@size]
        start = row*@size
        @check_match @models.slice(start, start + @size)

    column_matches: ->
      results = for row in [0...@size]
        @check_match @every_nth @size, row

    diagonal_matches: ->
      results = [
        @check_match @every_nth @size+1
        @check_match @every_nth @size-1, 0, @size-1, @length-@size
      ]

    look_for_matches: ->
      @each (cell) -> cell.set winning:false # csúnya hack
      @row_matches()
      @column_matches()
      @diagonal_matches()
      # @locked = true

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


  class SheetView extends Backbone.View
    el: $("#sheet")
    initialize: ->
      @collection.bind 'refresh', @render
    render: =>
      @collection.each(@add_one)
    add_one: (cell) =>
      one = new CellView model:cell, collection: @collection
      @el.append one.render().el

  window.sheet = new Sheet
  window.sheetview = new SheetView
    collection:sheet

# pamparam
  sheet.fetch()
  sheet.refresh()
#  sheet.refresh(sheet.create([
  #sheet.refresh [
    #{ value: 'foo'}
    #{ value: 'bar'}}
    #{ value: 'baz'}
    #{ value: 'bla'}
    #{ value: 'foo'}
    #{ value: 'foo'}
    #{ value: 'foo'}
    #{ value: 'bar'}
    #{ value: 'baz'}
    #{ value: 'bla'}
    #{ value: 'bar'}
    #{ value: 'baz' }
    #{ value: 'bla' }
    #{ value: 'bar'}
    #{ value: 'baz' }
    #{ value: 'bla' }
    #{ value: 'bar'}
    #{ value: 'baz'}
    #{ value: 'bla'}
    #{ value: 'bar'}
    #{ value: 'baz' }
    #{ value: 'bla' }
    #{ value: 'bar'}
    #{ value: 'baz' }
    #{ value: 'bla' }
  #]))
