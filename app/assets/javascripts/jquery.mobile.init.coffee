$(document).bind 'mobileinit',->
  $.mobile.ajaxEnabled = false
  $.mobile.linkBindingEnabled = false
  $.mobile.hashListeningEnabled = false
  $.mobile.pushStateEnabled = false
  @

 $.ajaxSetup({cache:false})

$('div[data-role="page"]').live('pagehide',(event, ui)->
      $(event.currentTarget).remove()
)
