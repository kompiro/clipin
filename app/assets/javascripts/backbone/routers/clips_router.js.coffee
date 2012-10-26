class Clipin.Routers.ClipsState

  constructor:(args)->
    @clips = args.clips
    @page = 1
    @loading = false

  title:->
    return 'All'

  fetch_args:()->
    add = @page > 1
    url = '/clips'
    data =
      page : @page if @page isnt 1
    @page = @page + 1
    result =
      url  : url
      data : data
      add  : add
    return result

  fetch:(@callback)->
    return if @loading
    @loading = true
    success = (clips)=>
      @loading = false
      @callback clips if @callback?

    args = @fetch_args()
    @clips.fetch
      url     : args.url
      data    : args.data
      add     : args.add
      success : success

class Clipin.Routers.TagState extends Clipin.Routers.ClipsState

  constructor:(args)->
    @tag = args.tag
    super(args)

  title:->
    return "Tag: #{@tag}"

  fetch_args:()->
    add = @page > 1
    url = '/clips'
    data =
      tag: @tag
      page : @page if @page isnt 1
    @page = @page + 1
    result =
      url  : url
      data : data
      add  : add
    return result

class Clipin.Routers.SearchState extends Clipin.Routers.ClipsState

  constructor:(args)->
    @query = args.query
    super(args)

  title:->
    return "Search: '#{@query}'"

  fetch_args:()->
    add = @page > 1
    url = '/clips/search'
    data =
      q:@query
      page : @page if @page isnt 1
    @page = @page + 1
    result =
      url  : url
      data : data
      add  : add
    return result

class Clipin.Routers.ClipsRouter extends Backbone.Router

  initialize: (options) ->

    @clips = new Clipin.Collections.ClipsCollection(options.clips)
    @tags = new Clipin.Collections.TagsCollection(options.tags)
    @current_page = null
    @menuView = new Clipin.Views.Clips.MenuView(model:
      tags:@tags
    )
    @menuView.render()
    @headerView = new Clipin.Views.Clips.HeaderView()
    @listView = new Clipin.Views.Clips.ClipsListView(
      clips: @clips
      tags: @tags
    )

  routes:
    "new"           : "new"
    ""              : "index"
    "_=_"           : "index"
    "index"         : "all"
    "index/:tag"    : "by_tag"
    "search/:query" : "search"
    "conf"          : "conf"
    "extension"     : "extension"
    ":id/edit"      : "edit"
    ":id"           : "show"

  new: ->
    page = new Clipin.Views.Clips.NewView(
      collection: @clips
      router : @
    )
    @changePage(page)

  index: ->
    @menuView.active('All')
    @listView.setState new Clipin.Routers.ClipsState(
      clips : @clips
    )
    @showListView()

  all:->
    @menuView.active('All')
    @listView.setState new Clipin.Routers.ClipsState(
      clips : @clips
    )
    @listView.fetch(=>
      @showListView()
    )

  by_tag:(tag)->
    @menuView.active(tag)
    @listView.setState new Clipin.Routers.TagState(
      clips : @clips
      tag : tag
    )
    @listView.fetch(=>
      @showListView()
    )

  search:(query)->
    @menuView.active('')
    @listView.setState new Clipin.Routers.SearchState(
      clips : @clips
      query : query
    )
    @listView.fetch(=>
      @showListView()
    )

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

  showListView:->
    @changePage(@listView)

  changePage:(page)->
    if @current_page and page is @current_page
      window.scrollTo(0)
      return
    if @current_page
      @current_page.$el.trigger('pagehide')
      @current_page.remove()
    $("#page").append(page.render().el)
    page.$el.trigger('pageshow')
    window.scrollTo(0)
    @current_page = page
