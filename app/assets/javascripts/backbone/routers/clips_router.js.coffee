class Clipin.Routers.ClipsRouter extends Backbone.Router
  initialize: (options) ->
    @clips = new Clipin.Collections.ClipsCollection()
    @clips.reset options.clips

  routes:
    "/new"      : "newClip"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newClip: ->
    @view = new Clipin.Views.Clips.NewView(collection: @clips)
    $("#clips").html(@view.render().el)

  index: ->
    @view = new Clipin.Views.Clips.IndexView(clips: @clips)
    $("#clips").html(@view.render().el)
    $("#clips").find("ul").listview()

  show: (id) ->
    clip = @clips.get(id)

    @view = new Clipin.Views.Clips.ShowView(model: clip)
    $("#clips").html(@view.render().el)

  edit: (id) ->
    clip = @clips.get(id)

    @view = new Clipin.Views.Clips.EditView(model: clip)
    $("#clips").html(@view.render().el)
