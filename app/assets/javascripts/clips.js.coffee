# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

page_num = 2
loading = false

$(window).scroll(()->
  if  $(window).scrollTop() > $(document).height() - $(window).height() - 100
    lastPostFunc(page_num)
)
lastPostFunc = (count)->
  unless loading
    loading = true
    $.get '/clips.json',
      page: count
      , (clips)->
        console.log clips
        for clip in clips
          $("#clip_list").append("<li>#{clip.title}</li>")
        $("#clip_list").listview('refresh')
        loading = false
        page_num = page_num + 1
