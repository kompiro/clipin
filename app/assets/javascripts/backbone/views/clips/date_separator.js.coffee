class Clipin.Views.Clips.DateSeparatorView extends Backbone.View

  tagName: "li"

  render: ->
    $(@el).attr('data-role','list-divider')
    $(@el).html(moment(@model).format('YYYY/MM/DD'))
    return this
