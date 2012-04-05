Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.NewView extends Backbone.View
  template: JST["backbone/templates/clips/new"]

  events:
    "submit #new-clip": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (clip) =>
        @model = clip
        window.location.hash = "/#{@model.id}"

      error: (clip, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
