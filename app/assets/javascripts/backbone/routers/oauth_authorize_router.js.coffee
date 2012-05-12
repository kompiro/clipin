
class Clipin.Routers.OAuthAuthorizeRouter extends Backbone.Router
  initialize: (options) ->
    @model = new Clipin.Models.OAuth(options.model)
    @model.set('client_secret',options.client_secret)
    @model.set('response_type',options.response_type)

  routes:
    ".*"       : "init"

  init: ->
    page = new Clipin.Views.OAuth.AuthorizeView(
      router: @
      model: @model
    )
    @changePage(page)

  changePage:(page)->
    $(page.el).attr('data-role','page')
    page.render()
    $('body').append($(page.el))
    $.mobile.changePage($(page.el),changeHash:false)
