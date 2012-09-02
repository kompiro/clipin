class Clipin.Routers.ClipsRouter extends Backbone.Router
  initialize: (options) ->
    @clips = new Clipin.Collections.ClipsCollection(options.clips)
    @clips.url = options.path
    @tags = new Clipin.Collections.TagsCollection(options.tags)
    @title = options.title
    @clips.reset options.clips
    @current_page = null
    @menuView = new Clipin.Views.Clips.MenuView(model:@tags)
    @menuView.render()

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
    @clips.fetch
     success:(collection)=>
       @clips.reset(collection.models)
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
    @current_page.$el.trigger('pagehide') if @current_page
    page.render()
    page.$el.trigger('pageshow')
    @current_page = page
