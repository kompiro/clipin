Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.NewView extends Backbone.View
  template: JST["backbone/templates/clips/new"]

  events:
    "submit #new-clip": "save"

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
    $.mobile.showPageLoadingMsg()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (clip) =>
        @model = clip
        $.mobile.hidePageLoadingMsg()
        @router.navigate("index",{trigger:true})

      error: (clip, jqXHR) =>
        $.mobile.hidePageLoadingMsg()
        @model.set({errors: $.parseJSON(jqXHR.responseText)})

      at:0
    )

  render: ->
    $(@el).html(@template(@model.toJSON()))

    this.$("form").backboneLink(@model)

    return this
