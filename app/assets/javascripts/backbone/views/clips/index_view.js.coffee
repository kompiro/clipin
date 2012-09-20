Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.IndexView extends Backbone.View
  el: "#page"
  template: JST["backbone/templates/clips/index"]

  events:
    "pagehide" : "pagehide"
    "pageshow" : "pageshow"
    "click .next_clips" : "loadNext"

  initialize: () ->
    @options.clips.bind('reset', @addAll)
    @options.clips.bind('add', @add)
    @tag = @options.tag
    @page_num = 2
    @last_length = @options.clips.length
    @loading = false

  loadNext:(e)=>
    e.preventDefault()
    e.stopPropagation()
    @lastPostFunc()

  scroll:()=>
    # timeout to permit multiposting
    setTimeout =>
      if  $(window).scrollTop() > $(document).height() - $(window).height() - 100
        @lastPostFunc()
    , 100


  lastPostFunc : ()->
    unless @loading
      @loading = true
      if @tag
        @options.clips.fetch(
          add:true
          data:
            page:@page_num
            tag: @tag
          success:(clips)=>
            @updateLoadingInformation(clips)
        )
      else
        @options.clips.fetch(
          add:true
          data:
            page:@page_num
          success:(clips)=>
            @updateLoadingInformation(clips)
        )

  updateLoadingInformation : (clips)->
    if clips.length is @last_length
      @loading = true
      @el_next_clip().css('display','none')
      return
    @last_length = clips.length
    @loading = false
    @page_num = @page_num + 1

  addAll: () =>
    @options.clips.each(@addOne)

  add:(clip,clips,options)=>
    @addOne(clip,options.index,clips.models)

  addOne: (clip,index,clips) =>
    if index is 0 or not clips[index - 1].same_updated_date(clip)
      separator = new Clipin.Views.Clips.DateSeparatorView({model:clip.toJSON().created_at})
      @el_clip_list().append(separator.render().el)

    view = new Clipin.Views.Clips.ClipView({model : clip})
    @el_clip_list().append(view.render().el)

  render: =>
    $(@el).html(@template(title:@options.title))
    @addAll()

    return this

  pageshow:->
    $(window).scroll(@scroll)
    @el_next_clip().css('display','')

  pagehide:->
    $(window).unbind('scroll',@scroll)

  el_next_clip:->
    $(@el).find('.next_clips')

  el_clip_list : ->
    $(@el).find('.clip_list')

class Clipin.Views.Clips.DateSeparatorView extends Backbone.View
  tagName: "div"
  className: "date-separator"
  render: ->
    $(@el).attr('data-role','list-divider')
    $(@el).html(moment(@model).format('YYYY/MM/DD'))
    return this
