class Clipin.Routers.ClipsRouter extends Backbone.Router
  initialize: (options) ->
    @clips = new Clipin.Collections.ClipsCollection()
    @clips.url = options.path
    @title = options.title
    @clips.reset options.clips

  routes:
    "new"      : "newClip"
    "index"    : "index_fetch"
    "conf"     : "conf"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"

  newClip: ->
    page = new Clipin.Views.Clips.NewView(
      collection: @clips
      router : @
    )
    @changePage(page)

  index_fetch:->
    @clips.fetch()
    @index()

  index: ->
    page = new Clipin.Views.Clips.IndexView(
      clips: @clips
      title: @title
    )
    @changePage(page)

  conf: ->
    page = new Clipin.Views.Clips.ConfView()
    @changePage(page)

  show: (id) ->
    @edit id

  edit: (id) ->
    clip = @clips.get(id)
    if clip?
      @show_edit_view clip
      return
    clip = new Clipin.Models.Clip(id:id)
    clip.fetch
      success:(clip)=>
        @show_edit_view clip

  show_edit_view: (clip)->
    page = new Clipin.Views.Clips.EditView(
      model: clip
      router : @
    )
    @changePage(page)
    try
      twttr.widgets.load()
      FB.XFBML.parse()
    catch error

  changePage:(page)->
    $(page.el).attr('data-role','page')
    page.render()
    $('body').append($(page.el))
    $.mobile.changePage($(page.el),changeHash:false)
