#= require backbone/routers/clips_router

describe 'TagState',->
  beforeEach ->
    @collection = new Backbone.Collection()
    @collection.url = '/clips'
    @collection.model = Clipin.Models.Clip

    @state = new Clipin.Routers.TagState
      clips:@collection
      tag:'test'

  it 'has loading attribute',->
    expect(@state.loading).toBe(false)
  it 'has page attribute', ->
    expect(@state.page).toBe(1)
  it 'returns All when call title',->
    expect(@state.title).toBe('Tag: test')
  it 'returns url',->
    expect(@state.url).toBe('/clips')

  describe 'fetch_args',->
    describe 'page is 1',->
      beforeEach ->
        @args = @state.fetch_args()
      it 'does not return null data',->
        expect(@args.data).not.toEqual(null)
      describe 'data',->
        beforeEach ->
          @data = @args.data
        it 'has tag',->
          expect(@data.tag).toBe('test')
        it 'has not page',->
          expect(@data.page).toBe(undefined)
    describe 'page is 2',->
      beforeEach ->
        @state.page = 2
        @args = @state.fetch_args()
      it 'does not return null data',->
        expect(@args.data).not.toEqual(null)
      describe 'data',->
        beforeEach ->
          @data = @args.data
        it 'has tag',->
          expect(@data.tag).toBe('test')
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
