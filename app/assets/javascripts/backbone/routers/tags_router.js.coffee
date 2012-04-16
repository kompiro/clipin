class Clipin.Routers.TagsRouter extends Backbone.Router
  initialize: (options) ->
    @tags = new Clipin.Collections.TagsCollection()
    @tags.reset options.tags

  routes:
    "new"      : "newTag"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newTag: ->
    page = new Clipin.Views.Tags.NewView(collection: @tags)
    @changePage(page)

  index: ->
    page = new Clipin.Views.Tags.IndexView(tags: @tags)
    @changePage(page)

  show: (id) ->
    tag = @tags.get(id)

    page = new Clipin.Views.Tags.ShowView(model: tag)
    @changePage(page)

  edit: (id) ->
    tag = @tags.get(id)

    @view = new Clipin.Views.Tags.EditView(model: tag)
    $("#tags").html(@view.render().el)

  changePage:(page)->
    $(page.el).attr('data-role','page')
    page.render()
    $('body').append($(page.el))
    $.mobile.changePage($(page.el),changeHash:false)
