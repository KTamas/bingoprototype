$(document).ready ->
  class Page extends Backbone.View
    render_template: (p) -> _.template($('#' + @template).html(), p)
    render: ->
      $(@el).html @render_template()
      super

  class Egyik extends Page
    template: 'egyik'


  class App extends Backbone.Controller
    routes:
      ':page': 'show'
    initialize: ->
      @egyik = new Egyik()
    replace_body: (page) ->
      $('body').children().remove()
      $('body').append(page)
    show: (page) ->
      @replace_body(@[page].render().el)

  window.app = new App()
  Backbone.history.start()
