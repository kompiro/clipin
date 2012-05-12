Clipin.Views.OAuth ||= {}

class Clipin.Views.OAuth.NewView extends Backbone.View
  template: JST["backbone/templates/oauth/new"]

  events:
    "submit #new-oauth": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()
    @router = options.router

    @model.bind("change:errors", (model,errors) =>
      if errors?
        if errors.url?
          _.each(errors.url,(error)->
            $('.error_explanation').append("<li>#{error}</li>")
          )
      else
        $('.error_explanation').html('')
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (model) =>
        @router.show(model)

      error: (clip, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})

    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
