Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.EditView extends Backbone.View
  template : JST["backbone/templates/clips/edit"]
  id: "edit_clip"

  events :
    "click .clip_save"   : "save"
    "click .clip_trash"  : "trash"
    "click .btn_back"    : "back"
    "pageshow"           : "pageshow"

  initialize : (options)->
    @tags = options.tags
    @router = options.router

  trash : ->
    @model.save trash : true,
      success:(model)->
        model.collection.remove model
        @router.navigate("index",{trigger:true})

  save:(e)->
    e.preventDefault()
    e.stopPropagation()
    tags = $('#clip_tags').tagit('assignedTags')
    @model.save tags : tags,
      success:->
        @router.navigate("index",{trigger:true})

  back : ->
    history.back()

  render : ->
    $(@el).html(@template(@model.toJSON()))
    info_view = new Clipin.Views.Clips.ClipInfoView(
      model:@model
    )
    $(@el).find('#clip-info').replaceWith(info_view.render().el)
    return this

  pageshow : ->
    availableTags = @tags.map((tag)->
      tag.toJSON().name
    )
    $('#clip_tags').tagit(
      availableTags: availableTags
    )
    content = $(@el).find('#content')
    content.css(
      color: '#333'
    ).spin()
