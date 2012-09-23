Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.MenuView extends Backbone.View
  template: JST["backbone/templates/clips/menu"]

  el:"#menu"

  render: ->
    $(@el).html(@template())
    @addOne new Backbone.Model(name:'All')
    @model.tags.each(@addOne)
    return this

  addOne:(menuItem)=>
    itemView = new Clipin.Views.Clips.MenuItemView(model:menuItem)
    $(@el).append(itemView.render().el)

  active:(menuItemName)->
    @$el.children().each ->
      $(@).removeClass('active')
      if $(@).text().replace(/(^\s+)|(\s+$)/g, "") is menuItemName
        $(@).addClass('active')


class Clipin.Views.Clips.MenuItemView extends Backbone.View
  template: JST["backbone/templates/clips/menu_item"]
  tagName:"li"

  render: ->
    $(@el).html(@template(item:@model.toJSON()))
    return this

