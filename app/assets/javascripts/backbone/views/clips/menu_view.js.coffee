Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.MenuView extends Backbone.View
  template: JST["backbone/templates/clips/menu"]

  el:"#menu-list"

  initialize:(opt)->
    @router = opt.router

  render: ->
    $(@el).html(@template())
    @addTag new Backbone.Model(name:'All')
    @model.tags.each(@addTag)
    return this

  addTag:(menuItem)=>
    itemView = new Clipin.Views.Clips.MenuItemView(model:menuItem)
    $(@el).append(itemView.render().el)

  active:(menuItemName)->
    @reset =>
      $('.nav.menu').children().each ->
        if $(@).text().replace(/(^\s+)|(\s+$)/g, "") is menuItemName
          $(@).addClass('active')

  reset:(callback)->
    $('.nav.menu').children().each ->
      $(@).removeClass('active')
    callback() if callback?

class Clipin.Views.Clips.MenuItemView extends Backbone.View
  template: JST["backbone/templates/clips/menu_item"]
  tagName:"li"

  render: ->
    $(@el).html(@template(item:@model.toJSON()))
    return this

