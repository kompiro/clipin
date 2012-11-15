Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.NewView extends Backbone.View
  id:"new_clip"
  template: JST["backbone/templates/clips/new"]

  events:
    "click #new-clip": "save"
    'keypress input[type=text]': 'saveOnEnter'

  constructor: (options) ->
    super(options)
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
    @saving_element.show()

    @model.unset("errors")
    @model.save(null,

      success: (clip) =>
        @collection.add(clip.clone(),
          at:0
        )
        @model.clear()
        @saving_element.hide()

      error: (clip, jqXHR) =>
        if jqXHR.status == 500
          @model.set
            errors:
              url:["Clipping \"#{clip.get('url')}\" : #{jqXHR.statusText}"]
        else
          @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  saveOnEnter:(e)->
    return if(e.keyCode isnt 13)
    @save(e)

  render: ->
    $(@el).html(@template(@model.toJSON()))

    @.$("form").backboneLink(@model)
    el = @.$("#url")
    el.on('postpaste',=>
      @model.set('url',el.val())).pasteEvents()
    @

  pageshow:->
    @saving_element = $(@el).find('#saving')
    @saving_element.css(
      color:'#333'
    )
    @saving_element.spin()
    @saving_element.hide()
