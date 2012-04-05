Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.IndexView extends Backbone.View
  template: JST["backbone/templates/clips/index"]

  initialize: () ->
    @options.clips.bind('reset', @addAll)

  addAll: () =>
    @options.clips.each(@addOne)

  addOne: (clip) =>
    view = new Clipin.Views.Clips.ClipView({model : clip})
    @$("ul").append(view.render().el)

  render: =>
    $(@el).html(@template(clips: @options.clips.toJSON() ))
    @addAll()

    return this
