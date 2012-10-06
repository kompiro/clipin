
Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.ClipInfoView extends Backbone.View
  template : JST["backbone/templates/clips/clip_info"]

  render : ->
    $(@el).html(@template(@model.toJSON()))
    return this
