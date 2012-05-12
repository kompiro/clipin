class Clipin.Routers.OAuthRouter extends Backbone.Router
  initialize: (options) ->
    @collection = new Clipin.Collections.OAuthCollection()

  routes:
    ".*"        : "new"
    ":id"      : "show"

  new: ->
    page = new Clipin.Views.OAuth.NewView(
      collection : @collection
      router: @
    )
    @changePage(page)

  show: (model)->
     page = new Clipin.Views.OAuth.ShowView(
       model : model
     )
     @changePage(page)

  changePage:(page)->
    $(page.el).attr('data-role','page')
    page.render()
    $('body').append($(page.el))
    $.mobile.changePage($(page.el),changeHash:false)
