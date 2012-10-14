
Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.ConfView extends Backbone.View
  template: JST["backbone/templates/clips/conf"]
  id:"configuration"

  events:
    'click .save_tags_color' : 'save'
    'pageshow' : 'pageshow'

  render: ->
    $(@el).html(@template())
    @model.each (tag)=>
      view = new Clipin.Views.Clips.TagConfView
        model: tag
      $(@el).find('tbody').append(view.render().el)
    return @

  pageshow: ->
    $(@el).find('#conftabs a').click (evt)->
      evt.preventDefault()
      $(this).tab('show')

  save:->
    @model.each (tag)->
      if tag.hasChanged 'color'
        tag.change()
        tag.save()


class Clipin.Views.Clips.TagConfView extends Backbone.View
  template: JST["backbone/templates/clips/tag_conf"]
  tagName: 'tr'

  render:->
    $(@el).html(@template(@model.toJSON()))
    sample_view = new Clipin.Views.Clips.TagView
      model: @model
    $(@el).find("td[id='tags[#{@model.id}][color]']").html(sample_view.render().el)
    $(@el).find("select[name='tags[#{@model.id}][color]']").on('change',(evt)=>
      sample_view.$el.removeClass(tagColor(@model.get('color')))
      @model.set 'color',Number(evt.currentTarget.value),
        silent:true
      sample_view.$el.addClass(tagColor(@model.get('color')))
    )
    return @

class Clipin.Views.Clips.TagView extends Backbone.View
  tagName: 'span'
  className: 'tag'

  render:->
    $(@el).addClass(tagColor(@model.get('color')))
    $(@el).text(@model.get('name'))
    return @


