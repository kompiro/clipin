Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.NewView extends Backbone.View
  template: JST["backbone/templates/clips/new"]
  id:"new_clip"

  events:
    "click #new-clip": "save"

  constructor: (options) ->
    super(options)
    @router = options.router
    @model = new @collection.model()

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
      success: (clip) =>
        @model = clip
        @router.navigate("index",{trigger:true})

      error: (clip, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})

      at:0
    )

  render: ->
    $(@el).html(@template(@model.toJSON()))

    this.$("form").backboneLink(@model)

    return this
