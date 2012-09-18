class Clipin.Routers.ClipsRouter extends Backbone.Router
  initialize: (options) ->
    @clips = new Clipin.Collections.ClipsCollection()
    @tags = new Clipin.Collections.TagsCollection(options.tags)
    @title = options.title
    @clips.reset options.clips
    @current_page = null
    @menuView = new Clipin.Views.Clips.MenuView(model:@tags)
    @menuView.render()
    @headerView = new Clipin.Views.Clips.HeaderView()

  routes:
    "new"           : "new"
    "search/:query" : "search"
    "index/:tag"    : "index_by_tag"
    "index"         : "index_fetch"
    "conf"          : "conf"
    "_=_"           : "index"
    ":id/edit"      : "edit"
    ":id"           : "show"
    ""            : "index"

  new: ->
    page = new Clipin.Views.Clips.NewView(
      collection: @clips
      router : @
    )
    @changePage(page)

  index_by_tag:(tag)->
    @clips.fetch
      data:
        tag:tag
      success:(collection)=>
        @clips.reset(collection.models)
        @index()

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

  search:(query)->
    @clips.fetch
      url:'/clips/search'
      data:
        q:query
      success:(collection)=>
        @clips.reset(collection.models)
        page = new Clipin.Views.Clips.IndexView(
          clips: @clips
          title: "Search : #{query}"
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
