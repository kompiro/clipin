Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.HeaderView extends Backbone.View

  el:"#header"

  events:
    "click .icon-search" : "search"
    "submit .navbar-search" : "search"

  search:(e)->
    e.preventDefault()
    e.stopPropagation()
    query = @$el.find('input.search-query').val()
    Backbone.history.navigate("search/#{query}",
      trigger:true
    )




