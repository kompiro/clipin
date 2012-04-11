class Clipin.Routers.ClipsRouter extends Backbone.Router
  initialize: (options) ->
    @clips = new Clipin.Collections.ClipsCollection()
    @clips.reset options.clips

  routes:
    "new"      : "newClip"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newClip: ->
    console.log 'new'
    page = new Clipin.Views.Clips.NewView(
      collection: @clips
      router : @
    )
    @changePage(page)

  index: ->
    console.log 'index'
    page = new Clipin.Views.Clips.IndexView(clips: @clips)
    @changePage(page)

  show: (id) ->
    clip = @clips.get(id)

    @view = new Clipin.Views.Clips.ShowView(model: clip)
    $("#clips").html(@view.render().el)

  edit: (id) ->
    clip = @clips.get(id)

    page = new Clipin.Views.Clips.EditView(model: clip)
    @changePage(page)

  changePage:(page)->
    $(page.el).attr('data-role','page')
    page.render()
    $('body').append($(page.el))
    $.mobile.changePage($(page.el),changeHash:false)
