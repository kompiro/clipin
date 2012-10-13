Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.ClipView extends Backbone.View
  template: JST["backbone/templates/clips/clip"]

  events:
    "click .destroy" : "destroy"

  tagName: "div"
  className: "clip"

  destroy: () ->
    @model.destroy()
    @remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this
