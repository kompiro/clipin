
Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.ExtensionView extends Backbone.View
  template: JST["backbone/templates/clips/extension"]
  id:"extension"

  render: ->
    $(@el).html(@template())
    return this
