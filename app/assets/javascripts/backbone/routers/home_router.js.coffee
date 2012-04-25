class Clipin.Routers.HomeRouter extends Backbone.Router
  initialize: (options) ->

  routes:
    ".*"        : "index"

  index: ->
    page = new Clipin.Views.Login.ShowView()
    @changePage(page)

  changePage:(page)->
    $(page.el).attr('data-role','page')
    page.render()
    $('body').append($(page.el))
    $.mobile.changePage($(page.el),changeHash:false)
