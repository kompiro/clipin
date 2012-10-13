
Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.ConfView extends Backbone.View
  template: JST["backbone/templates/clips/conf"]
  id:"configuration"

  events:
    'click .save_tags_color' : 'save'

  render: ->
    $(@el).html(@template())
    @model.each (tag)=>
      view = new Clipin.Views.Clips.TagConfView
        model: tag
      $(@el).find('#tag_list').append(view.render().el)
    return @

  save:->
    @model.each (tag)->
      tag.save()

class Clipin.Views.Clips.TagConfView extends Backbone.View
  template: JST["backbone/templates/clips/tag_conf"]

  render:->
    $(@el).html(@template(@model.toJSON()))
    $(@el).find("select[name='tags[#{@model.id}][color]']").bind('change',(evt)=>
      @model.set('color',Number(evt.currentTarget.value))
    )
    return @
