class Sheet extends Backbone.Collection
  initialize: ->
    @__defineGetter__ 'size', -> Math.sqrt @length

  model: Cell
 # url: '/wordlist'


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
    #_.reduce results, (p,c) -> p || c

  column_matches: ->
    results = for row in [0...@size]
      @check_match @every_nth @size, row
    _.reduce results, (p,c) -> p || c

  diagonal_matches: ->
    results = [
      @check_match @every_nth @size+1
      @check_match @every_nth @size-1, 0, @size-1, @length-@size
    ]
    _.reduce results, (p,c) -> p || c

  look_for_matches: ->
    @each (cell) -> cell.set winning:false # csúnya hack
    @row_matches()
    @column_matches()
    @diagonal_matches()
    # @locked = true
