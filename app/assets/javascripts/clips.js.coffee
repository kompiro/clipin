# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

page_num = 2
loading = false

$(window).scroll(()->
  if  $(window).scrollTop() > $(document).height() - $(window).height() - 100
    lastPostFunc(page_num)
)
$('#next_clips').click(lastPostFunc)
lastPostFunc = (count)->
  unless loading
    loading = true
    $.get '/clips.json',
      page: count
      , (clips)->
        if clips.length is 0
          loading = true
          $('#next_clips').css('display','none')
          return
        for clip in clips
          $("#clip_list").append(JST['templates/clip_item'](clip:clip))
        $("#clip_list").listview('refresh')
        loading = false
        page_num = page_num + 1
