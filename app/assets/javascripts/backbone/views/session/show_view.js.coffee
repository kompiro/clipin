Clipin.Views.Session ||= {}

class Clipin.Views.Session.NewView extends Backbone.View
  el: "#page"
  template: JST["backbone/templates/session/new"]

  render: ->
    $(@el).html(@template())
    return this
