#= require backbone/routers/clips_router

describe 'ClipsState',->
  beforeEach ->
    @collection = new Backbone.Collection()
    @collection.url = '/clips'
    @collection.model = Clipin.Models.Clip

    @state = new Clipin.Routers.ClipsState clips:@collection

  it 'has loading attribute',->
    expect(@state.loading).toBe(false)
  it 'has page attribute', ->
    expect(@state.page).toBe(1)
  it 'returns All when call title',->
    expect(@state.title()).toBe('All')

  describe 'fetch_args',->
    describe 'page is 1',->
      beforeEach ->
        @args = @state.fetch_args()
      it 'returns url',->
        expect(@args.url).toBe('/clips')
      it 'returns add is false',->
        expect(@args.add).toBe(false)
      it 'returns null data',->
        expect(@args.data).toEqual(null)
    describe 'page is 2',->
      beforeEach ->
        @state.page = 2
        @args = @state.fetch_args()
      it 'returns url',->
        expect(@args.url).toBe('/clips')
      it 'returns add is false',->
        expect(@args.add).toBe(true)
      it 'does not return null data',->
        expect(@args.data).not.toEqual(null)
      describe 'data',->
        beforeEach ->
          @data = @args.data
        it 'has page',->
          expect(@data.page).toBe(2)

  describe 'fetch',->
    describe 'when loading',->
      it 'does not call callback',->
        @state.loading = true
        callback = ->
          throw new Error('should not be called.')
        @state.fetch(callback)
    describe 'not loading',->
      it 'call fetch clips',->
        spyOn(@collection,'fetch')
        callback = ->
        @state.fetch(callback)
        expect(@collection.fetch).toHaveBeenCalled()




describe 'ClipsRouter routes',->
  beforeEach ->
    @routeSpy = jasmine.createSpy('route')
    @collection = new Backbone.Collection()
    @tags = new Backbone.Collection()
    @tags.url ='/tags'
    @tags.model = Clipin.Models.Tag
    @fetchStub = spyOn(@collection,'fetch').andReturn(new Backbone.Collection())
    @collection.url = '/clips'
    @collection.model = Clipin.Models.Clip
    dummyView = new Backbone.View()
    dummyView.setState = ->
    dummyView.fetch = ->
    @clipViewStub = spyOn(Clipin.Views.Clips,'ClipsListView').andReturn(dummyView)
    @clipsCollectionStub = spyOn(Clipin.Collections,'ClipsCollection').andReturn(@collection)
    @router = new Clipin.Routers.ClipsRouter {}
    if(not(Backbone.History.started))
      try
        Backbone.history.start
          silent:true
          pushState:true
      catch e
        console.log e

  afterEach ->
    @router.navigate 'jasmine'
    #Clipin.Views.Clips.ClipsListView.restore()
    #Clipin.Collections.ClipsCollection.restore()

  it 'fires the index hash with a blank hash',->
    @router.bind 'route:index',@routeSpy
    @router.navigate '',true
    expect(@routeSpy).toHaveBeenCalled()
    expect(@routeSpy).toHaveBeenCalledWith()

  it 'fires the index hash with a initial string',->
    @router.bind 'route:index',@routeSpy
    @router.navigate '_=_',true
    expect(@routeSpy).toHaveBeenCalled()
    expect(@routeSpy).toHaveBeenCalledWith()

  it 'fires the clip detail route',->
    @router.bind 'route:show',@routeSpy
    @router.navigate '1',true
    expect(@routeSpy).toHaveBeenCalled()
    expect(@routeSpy).toHaveBeenCalledWith('1')

  it 'fires the clip edit route',->
    @router.bind 'route:edit',@routeSpy
    @router.navigate '1/edit',true
    expect(@routeSpy).toHaveBeenCalled()
    expect(@routeSpy).toHaveBeenCalledWith('1')

  it 'fires new clip route',->
    @router.bind 'route:new',@routeSpy
    @router.navigate 'new',true
    expect(@routeSpy).toHaveBeenCalled()
    expect(@routeSpy).toHaveBeenCalledWith()

  it 'fires the index and fetch route',->
    @router.bind 'route:all',@routeSpy
    @router.navigate 'index',true
    expect(@routeSpy).toHaveBeenCalled()
    expect(@routeSpy).toHaveBeenCalledWith()

  it 'fires the index by tag route',->
    @router.bind 'route:by_tag',@routeSpy
    @router.navigate 'index/articles',true
    expect(@routeSpy).toHaveBeenCalled()
    expect(@routeSpy).toHaveBeenCalledWith('articles')

  it 'fires the configuration route',->
    @router.bind 'route:conf',@routeSpy
    @router.navigate 'conf',true
    expect(@routeSpy).toHaveBeenCalled()
    expect(@routeSpy).toHaveBeenCalledWith()

  it 'fires the search  route',->
    @router.bind 'route:search',@routeSpy
    @router.navigate 'search/articles',true
    expect(@routeSpy).toHaveBeenCalled()
    expect(@routeSpy).toHaveBeenCalledWith('articles')

  describe 'index handler',->

    it 'creates a Clip list collection',->
      @router.index()
      expect(@clipsCollectionStub).toHaveBeenCalled()
      expect(@clipViewStub).toHaveBeenCalledWith
        clips: @collection
        tags: @tags

    it 'creates a Clip list collection with tag',->
      @router.by_tag('article')
      expect(@clipsCollectionStub).toHaveBeenCalled()
      expect(@clipViewStub).toHaveBeenCalledWith
        clips: @collection
        tags: @tags

    it 'creates a Clip list collection with search query',->
      @router.search('article')
      expect(@clipsCollectionStub).toHaveBeenCalled()
      expect(@clipViewStub).toHaveBeenCalledWith
        clips: @collection
        tags: @tags
