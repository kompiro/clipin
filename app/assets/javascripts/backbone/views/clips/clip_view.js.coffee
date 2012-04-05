Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.ClipView extends Backbone.View
  template: JST["backbone/templates/clips/clip"]

  events:
    "click .destroy" : "destroy"

  tagName: "li"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
