Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.EditView extends Backbone.View
  template : JST["backbone/templates/clips/edit"]
  el: "#page"


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
    return this
