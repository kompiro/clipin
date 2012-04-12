class Clipin.Routers.ClipsRouter extends Backbone.Router
  initialize: (options) ->
    @clips = new Clipin.Collections.ClipsCollection()
    @pinned_clips = new Clipin.Collections.ClipsCollection()
    @pinned_clips.url = '/clips/pinned'
    @clips.reset options.clips
    @pinned_clips.reset options.pinned_clips

  routes:
    "new"      : "newClip"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newClip: ->
    page = new Clipin.Views.Clips.NewView(
      collection: @clips
      router : @
    )
    @changePage(page)

  index: ->
    page = new Clipin.Views.Clips.IndexView(
      clips: @clips
      pinned_clips: @pinned_clips
    )
    @changePage(page)

  show: (id) ->
    clip = @clips.get(id)

    @view = new Clipin.Views.Clips.ShowView(model: clip)
    $("#clips").html(@view.render().el)

  edit: (id) ->
    clip = @clips.get(id)

    page = new Clipin.Views.Clips.EditView(
      model: clip
      router : @
    )
    @changePage(page)

  changePage:(page)->
    $(page.el).attr('data-role','page')
    page.render()
    $('body').append($(page.el))
    $.mobile.changePage($(page.el),changeHash:false)
