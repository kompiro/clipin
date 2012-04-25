Clipin.Views.Login ||= {}

class Clipin.Views.Login.ShowView extends Backbone.View
  template: JST["backbone/templates/login/show"]

  render: ->
    $(@el).html(@template())
    return this
