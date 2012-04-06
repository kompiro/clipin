Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.IndexView extends Backbone.View
  template: JST["backbone/templates/clips/index"]

  initialize: () ->
    @options.clips.bind('reset', @addAll)
    @page_num = 2
    @loading = false

    $(window).scroll(()=>
      if  $(window).scrollTop() > $(document).height() - $(window).height() - 100
        @lastPostFunc()
    )
    @el_next_clip().live('click', =>
      @lastPostFunc()
    )

  lastPostFunc : ()->
    unless @loading
      @loading = true
      @options.clips.fetch(
        data:
          page:@page_num
        success:(clips)=>
          if clips.length is 0
            @loading = true
            @el_next_clip().css('display','none')
            return
          clips.each(@addOne)
          @el_clip_list().listview('refresh')
          @loading = false
          @page_num = @page_num + 1
      )

  addAll: () =>
    @options.clips.each(@addOne)

  addOne: (clip) =>
    view = new Clipin.Views.Clips.ClipView({model : clip})
    @el_clip_list().append(view.render().el)

  render: =>
    $(@el).html(@template(clips: @options.clips.toJSON() ))
    @addAll()

    return this

  el_next_clip:->
    $(@el).find('.next_clips')

  el_clip_list : ->
    $(@el).find('ul.clip_list')
