Clipin.Views.Tags ||= {}

class Clipin.Views.Tags.TagView extends Backbone.View
  template: JST["backbone/templates/tags/tag"]

  tagName: "li"

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
