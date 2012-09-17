#= require backbone/views/clips/index_view

describe 'clip index_view',->

  beforeEach ->
    @view = new Clipin.Views.Clips.IndexView
      clips: new Backbone.Collection

  xit 'should create a div element',->
    expect(@view.$el.nodeName).toEqual('div')
