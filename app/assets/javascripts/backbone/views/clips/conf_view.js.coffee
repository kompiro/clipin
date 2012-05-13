
Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.ConfView extends Backbone.View
  template: JST["backbone/templates/clips/conf"]

  render: ->
    $(@el).html(@template())
    return this
