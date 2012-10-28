Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.ClipView extends Backbone.View
  MAX_CHARS = 255
  AFTER_TEXT = '...'

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
    desc = $(@el).find('.description')
    descLength = desc.text().length
    descTrim = desc.text().substr(0,MAX_CHARS)
    if(MAX_CHARS < descLength)
      desc.html(descTrim + AFTER_TEXT).css(visibility:'visible')
    else
      desc.css(visibility:'visible')

    return this
