Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.HeaderView extends Backbone.View

  el:"#header"

  events:
    "click .icon-search" : "search"
    "submit .navbar-search" : "search"

  initialize:(opts)->
    @menuView = opts.menuView
    @router = opts.router

  search:(e)->
    e.preventDefault()
    e.stopPropagation()
    query = @$el.find('input.search-query').val()
    Backbone.history.navigate("search/#{query}",
      trigger:true
    )

  render:->
    datepicker =@$('.calendar')
    datepicker.attr('data-date',moment().format('YYYY/MM/DD'))
    datepicker.datepicker().on('changeDate',(ev)=>
      date = moment(ev.date).format('YYYY/MM/DD')
      @menuView.reset =>
        datepicker.datepicker('hide')
        @router.navigate("date/#{date}",{trigger:true})
    )

