Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.EditView extends Backbone.View
  template : JST["backbone/templates/clips/edit"]

  events :
    "vclick .clip_pin"    : "pin"
    "vclick .clip_unpin"  : "unpin"
    "vclick .clip_delete" : "delete"

  pin : ->
    console.log 'pin'

  delete : ->
    console.log 'delete'

  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this
