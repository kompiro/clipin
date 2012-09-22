#= require backbone/views/clips/clips_list_view

describe 'clip index_view',->

  beforeEach ->
    @view = new Clipin.Views.Clips.ClipsListView
      clips: new Backbone.Collection

  xit 'should create a div element',->
    expect(@view.$el.nodeName).toEqual('div')
