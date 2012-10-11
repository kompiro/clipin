Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.EditView extends Backbone.View
  template : JST["backbone/templates/clips/edit"]
  id: "edit_clip"

  events :
    "vclick .clip_pin"    : "pin"
    "vclick .clip_unpin"  : "unpin"
    "vclick .clip_trash"  : "trash"

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
    spinner = new Spinner().spin()
    $(spinner.el).css(
      left: '300px'
      top: '100px'
      color: '#333'
    )
    content.append(spinner.el)
    content.oembed(@model.get('url'),
      maxWidth:600
      maxHeight:450
      embedMethod: 'replace'
      beforeEmbed:(oembedData)=>
        unless oembedData.code
          info_view = new Clipin.Views.Clips.ClipInfoView(
            model:@model
          )
          content.replaceWith(info_view.render().el)
      afterEmbed: (oembedData)=>
        spinner.stop()
      onProviderNotFound: (container,resourceURL)=>
        info_view = new Clipin.Views.Clips.ClipInfoView(
          model:@model
        )
        content.replaceWith(info_view.render().el)
        spinner.stop()
    )
    return this
