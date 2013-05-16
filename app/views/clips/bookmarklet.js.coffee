load = ->
  loadJQuery = ->
    unless jQuery?
      script = d.createElement('script')
      script.id = 'clipin_jQuery'
      script.src = '//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js'
      document.body.appendChild script
      load()
    else
      body = jQuery('body')
      notification = jQuery(document.createElement('div'))
      content = jQuery(document.createElement('span'))
      content.text("Clip! '<%= raw @clip.title %>'").
        css('line-height', '46px').
        css('font-size', '18px')
      notification.append(content).height("50px").
        width("100%").
        css("background-color", "#fff").
        css("color", "#222").
        css("position", "fixed").
        css("filter", "progid:DXImageTransform.Microsoft.Alpha(opacity=95)").
        css("opacity", "0.95").
        css("-moz-opacity", "0.95").
        css("text-align", "center").
        css("left", "0px").
        css("top", "0px").
        css("z-index", "9999999").
        css("margin", "0px").
        css("padding", "0px") .
        appendTo(body).hide().fadeIn()
        setTimeout ->
          notification.fadeOut ->
            notification.remove()
            jQuery('#clipinjs').remove()
            jQuery('#clipin_jQeury').remove()
        ,3000
  setTimeout loadJQuery, 99

load()
