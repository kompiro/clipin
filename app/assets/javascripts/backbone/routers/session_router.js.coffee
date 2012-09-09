class Clipin.Routers.SessionRouter extends Backbone.Router
  initialize: (options) ->

  routes:
    ".*"        : "index"

  index: ->
    page = new Clipin.Views.Session.NewView()
    @changePage(page)

  changePage:(page)->
    @current_page.$el.trigger('pagehide') if @current_page
    page.render()
    page.$el.trigger('pageshow')
    @current_page = page
