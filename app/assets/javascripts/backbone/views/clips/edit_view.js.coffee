Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.EditView extends Backbone.View
  template : JST["backbone/templates/clips/edit"]
  id: "edit_clip"

  events :
    "click .clip_pin"    : "pin"
    "click .clip_unpin"  : "unpin"
    "click .clip_trash"  : "trash"
    "pageshow"           : "pageshow"

  pin : ->
    @model.save pin : true,
      success:->
        @router.navigate("index",{trigger:true})

  unpin : ->
    @model.save pin : false,
      success:->
        @router.navigate("index",{trigger:true})

  trash : ->
    @model.save trash : true,
      success:(model)->
        model.collection.remove model
        @router.navigate("index",{trigger:true})

  render : ->
    $(@el).html(@template(@model.toJSON()))
    content = $(@el).find('#content')
    content.oembed(@model.get('url'),
      maxWidth:600
      maxHeight:450
      embedMethod: 'replace'
      beforeEmbed:(oembedData)=>
        content.find('.spinner').stop()
        unless oembedData.code
          info_view = new Clipin.Views.Clips.ClipInfoView(
            model:@model
          )
          content.replaceWith(info_view.render().el)
      afterEmbed: (oembedData)=>
      onProviderNotFound: (container,resourceURL)=>
        info_view = new Clipin.Views.Clips.ClipInfoView(
          model:@model
        )
        content.replaceWith(info_view.render().el)
    )
    return this

  pageshow : ->
    content = $(@el).find('#content')
    content.css(
      color: '#333'
    ).spin()
