Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.EditView extends Backbone.View
  template : JST["backbone/templates/clips/edit"]

  events :
    "vclick .clip_pin"    : "pin"
    "vclick .clip_unpin"  : "unpin"
    "vclick .clip_delete" : "delete"

  pin : ->
    @model.save pin : true,
      success:->
        @router.navigate("index",{trigger:true})

  unpin : ->
    @model.save pin : false,
      success:->
        @router.navigate("index",{trigger:true})

  delete : ->
    console.log 'delete'

  render : ->
    $(@el).html(@template(@model.toJSON()))
    return this
