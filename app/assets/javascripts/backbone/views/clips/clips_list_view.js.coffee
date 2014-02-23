Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.ClipsListView extends Backbone.View
  id:'clips_list'
  template: JST["backbone/templates/clips/clips_list"]

  events:
    "pagehide" : "pagehide"
    "pageshow" : "pageshow"
    "click .next_clips" : "loadNext"

  initialize:()->
    @last_clips_length = 8

  loadNext:(e)=>
    e.preventDefault()
    e.stopPropagation()
    @lastPostFunc()

  scroll:()=>
    # timeout to permit multiposting
    setTimeout =>
      if  $(window).scrollTop() > $(document).height() - $(window).height() - 400
        @lastPostFunc()
    , 100

  setState : (state,callback)=>
    @state = state
    @fetch callback

  fetch :(callback)->
    @state.fetch callback

  lastPostFunc : ()->
    unless window.loading
      @loading_element.show()
      @el_next_clip().hide()
      @state.fetch((clips)=>
          finished = @last_clips_length is clips.length
          @last_clips_length = clips.length
          @updateLoadingInformation(clips,finished)
      )

  updateLoadingInformation : (clips,finished)->
    @loading_element.hide()
    if finished
      @el_next_clip().hide()
      @state.loading = true
      return
    @el_next_clip().show()

  addAll: () =>
    @el_clip_list().empty()
    @options.clips.each(@addOne)

  add:(clip,clips,options)=>
    @addOne(clip,options.at,clips.models,false)

  addOne: (clip,index,clips,all=true) =>
    if all and (index is 0 or not clips[index - 1].same_updated_date(clip))
      separator = new Clipin.Views.Clips.DateSeparatorView({model:clip.toJSON().updated_at})
      @el_clip_list().append(separator.render().el)
    view = new Clipin.Views.Clips.ClipView({model : clip})
    if index isnt 0 or all
      @el_clip_list().append(view.render().el)
    else
      el = view.render().el
      $(el).hide()
      @el_clip_list().prepend(el)
      $(el).slideDown()


  render: =>
    $(@el).html(@template())
    @addAll()
    @newView = new Clipin.Views.Clips.NewView(
      collection:@options.clips
    )
    $(@el).find('#new_clip').replaceWith(@newView.render().el)
    return this

  pageshow:->
    $(window).scroll(@scroll)
    @loading_element = $(@el).find('#loading')
    @loading_element.css(
      color:'#333'
    ).spin()
    @loading_element.hide()
    @el_next_clip().css('display','')
    @options.clips.bind('reset', @addAll)
    @options.clips.bind('add', @add)
    @newView.pageshow()

  pagehide:->
    $(window).unbind('scroll',@scroll)
    @options.clips.unbind('reset', @addAll)
    @options.clips.unbind('add', @add)

  el_next_clip:->
    $(@el).find('.next_clips')

  el_clip_list : ->
    $(@el).find('#clip_list')

class Clipin.Views.Clips.DateSeparatorView extends Backbone.View
  tagName: "div"
  className: "date-separator"
  render: ->
    $(@el).attr('data-role','list-divider')
    $(@el).html(moment(@model).format('YYYY/MM/DD'))
    return this
