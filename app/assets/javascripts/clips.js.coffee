# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


window.loadImgError = (source)->
  source.src = '/assets/not_found.png'
  source.onerror = ''
  true

window.TAG_COLOR =
  ['red','orange','yellow','light-green',
  'green','light-blue','blue','purple']
window.tagColor = (tag_id)->
  color = window.TAG_COLOR[tag_id % TAG_COLOR.length]
  "tag-#{color}"
