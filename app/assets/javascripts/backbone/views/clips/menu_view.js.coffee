Clipin.Views.Clips ||= {}

class Clipin.Views.Clips.MenuView extends Backbone.View
  template: JST["backbone/templates/clips/menu"]

  el:"#menu"

  initialize:(opt)->
    @router = opt.router

  date:(date)->
    datepicker = $(@el).find('.menu-date-input')
    datepicker.find('[name="date"]').val(date)

  render: ->
    $(@el).html(@template())
    @addTag new Backbone.Model(name:'All')
    @model.tags.each(@addTag)
    datepicker = $(@el).find('.menu-date-input')
    datepicker.attr('data-date',moment().format('YYYY/MM/DD'))
    datepicker.datepicker().on('changeDate',(ev)=>
      date = moment(ev.date).format('YYYY/MM/DD')
      @reset =>
        datepicker.datepicker('hide')
        @router.navigate("date/#{date}",{trigger:true})
    )
    return this

  addTag:(menuItem)=>
    itemView = new Clipin.Views.Clips.MenuItemView(model:menuItem)
    $(@el).append(itemView.render().el)

  active:(menuItemName)->
    @reset =>
      @$el.children().each ->
        if $(@).text().replace(/(^\s+)|(\s+$)/g, "") is menuItemName
          $(@).addClass('active')

  reset:(callback)->
    @$el.children().each ->
      $(@).removeClass('active')
    @$el.find('[name="date"]').val('')
    callback() if callback?

class Clipin.Views.Clips.MenuItemView extends Backbone.View
  template: JST["backbone/templates/clips/menu_item"]
  tagName:"li"

  render: ->
    $(@el).html(@template(item:@model.toJSON()))
    return this

