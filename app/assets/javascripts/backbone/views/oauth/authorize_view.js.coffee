
Clipin.Views.OAuth ||= {}

class Clipin.Views.OAuth.AuthorizeView extends Backbone.View
  template: JST["backbone/templates/oauth/authorize"]

  events:
    "submit #authorize-oauth": "save"

  constructor: (options) ->
    super(options)
    @router = options.router
    @model = options.model
    @model.url = '/oauth/allow'

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(@model.toJSON(),
      success: (model) =>
        window.close()

      error: (clip, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})

    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
