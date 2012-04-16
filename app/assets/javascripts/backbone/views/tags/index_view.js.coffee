Clipin.Views.Tags ||= {}

class Clipin.Views.Tags.IndexView extends Backbone.View
  template: JST["backbone/templates/tags/index"]

  initialize: () ->
    @options.tags.bind('reset', @addAll)

  addAll: () =>
    @options.tags.each(@addOne)

  addOne: (tag) =>
    view = new Clipin.Views.Tags.TagView({model : tag})
    @$(".tag_list").append(view.render().el)

  render: =>
    $(@el).html(@template(tags: @options.tags.toJSON() ))
    @$(".tag_list").append("<li data-theme='e'><a href='/clips/pinned'>Pin</a></li>")
    @$(".tag_list").append("<li data-theme='c'><a href='/clips'>Index</a></li>")
    @addAll()
    @$(".tag_list").append("<li data-theme='a'><a href='/clips/trashed'>Trash</a></li>")

    return this

