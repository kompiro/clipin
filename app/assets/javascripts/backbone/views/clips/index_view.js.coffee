Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.IndexView extends Backbone.View
  template: JST["backbone/templates/clips/index"]

  initialize: () ->
    @options.clips.bind('reset', @addAll)
    @options.clips.bind('add', @add)
    @page_num = 2
    @last_length = @options.clips.length
    @loading = false

    $(window).scroll(()=>
      if  $(window).scrollTop() > $(document).height() - $(window).height() - 100
        @lastPostFunc()
    )
    @el_next_clip().live('vclick', (e)=>
      e.preventDefault()
      e.stopPropagation()
      @lastPostFunc()
    )

  lastPostFunc : ()->
    unless @loading
      @loading = true
      @options.clips.fetch(
        add:true
        data:
          page:@page_num
        success:(clips)=>
          if clips.length is @last_length
            @loading = true
            @el_next_clip().css('display','none')
            return
          @el_clip_list().listview('refresh')
          @last_length = clips.length
          @loading = false
          @page_num = @page_num + 1
      )

  addAll: () =>
    if @options.pinned_clips.length isnt 0
      separator = new Clipin.Views.Clips.PinnedSeparatorView()
      @el_clip_list().append(separator.render().el)
      @options.pinned_clips.each(@addOne)
      separator = new Clipin.Views.Clips.AllSeparatorView()
      @el_clip_list().append(separator.render().el)
    @options.clips.each(@addOne)

  add:(clip,clips,options)=>
    @addOne(clip,options.index,clips.models)

  addOne: (clip,index,clips) =>
    if index is 0 or not clips[index - 1].same_created_date(clip)
      separator = new Clipin.Views.Clips.DateSeparatorView({model:clip.toJSON().created_at})
      @el_clip_list().append(separator.render().el)

    view = new Clipin.Views.Clips.ClipView({model : clip})
    @el_clip_list().append(view.render().el)

  render: =>
    $(@el).html(@template())
    @addAll()

    return this

  el_next_clip:->
    $(@el).find('.next_clips')

  el_clip_list : ->
    $(@el).find('ul.clip_list')

class Clipin.Views.Clips.PinnedSeparatorView extends Backbone.View
  tagName: "li"
  render: ->
    $(@el).attr('data-theme','e')
    $(@el).html('Pinned')
    return this

class Clipin.Views.Clips.AllSeparatorView extends Backbone.View
  tagName: "li"
  render: ->
    $(@el).attr('data-theme','d')
    $(@el).html('All')
    return this

class Clipin.Views.Clips.DateSeparatorView extends Backbone.View
  tagName: "li"
  render: ->
    $(@el).attr('data-role','list-divider')
    $(@el).html(moment(@model).format('YYYY/MM/DD'))
    return this
