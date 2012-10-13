class Clipin.Routers.ClipsRouter extends Backbone.Router
  initialize: (options) ->
    @clips = new Clipin.Collections.ClipsCollection()
    @tags = new Clipin.Collections.TagsCollection(options.tags)
    @clips.reset options.clips
    @current_page = null
    @menuView = new Clipin.Views.Clips.MenuView(model:
      tags:@tags
    )
    @menuView.render()
    @bind 'route:index_by_tag',(args)=>
      @menuView.active(args)
    @bind 'route:index_fetch',=>
      @menuView.active('All')
    @headerView = new Clipin.Views.Clips.HeaderView()

  routes:
    "new"           : "new"
    "search/:query" : "search"
    "index/:tag"    : "index_by_tag"
    "index"         : "index_fetch"
    "conf"          : "conf"
    "extension"     : "extension"
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
    page = new Clipin.Views.Clips.ClipsListView(
      clips: @clips
      title: "Tag: #{tag}"
      tag: tag
    )
    @clips.fetch
      data:
        tag:tag
      success:(collection)=>
        @clips.reset(collection.models)
        @changePage(page)

  index_fetch:->
    @clips.fetch
      success:(collection)=>
        @clips.reset(collection.models)
        @index()

  index: ->
    page = new Clipin.Views.Clips.ClipsListView(
      clips: @clips
      title: "All"
    )
    @changePage(page)

  search:(query)->
    page = new Clipin.Views.Clips.ClipsListView(
      clips: @clips
      title: "Search : #{query}"
      query: query
    )
    @clips.fetch
      url:'/clips/search'
      data:
        q:query
      success:(collection)=>
        @clips.reset(collection.models)
        @changePage(page)

  extension: ->
    page = new Clipin.Views.Clips.ExtensionView()
    @changePage(page)

  conf: ->
    page = new Clipin.Views.Clips.ConfView(
      model : @tags
    )
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
    if @current_page
      @current_page.$el.trigger('pagehide')
      @current_page.remove()
    $("#page").append(page.render().el)
    page.$el.trigger('pageshow')
    @current_page = page
