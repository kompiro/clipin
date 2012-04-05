Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.ShowView extends Backbone.View
  template: JST["backbone/templates/clips/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
