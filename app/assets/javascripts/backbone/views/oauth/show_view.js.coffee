
Clipin.Views.OAuth ||= {}

class Clipin.Views.OAuth.ShowView extends Backbone.View
  template: JST["backbone/templates/oauth/show"]

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this
