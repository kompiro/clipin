class Clipin.Models.Clip extends Backbone.Model
  paramRoot: 'clip'
  urlRoot: '/clips'

  defaults:
    title: null
    og_type: null
    image: null
    url: null
    description: null
    audio: null
    video: null
    created_at: null
    pin: false

  created_at_date:->
    moment(@get('created_at'))

  same_created_date:(target)->
    @created_at_date().diff(target.created_at_date(),'days') is 0

class Clipin.Collections.ClipsCollection extends Backbone.Collection
  model: Clipin.Models.Clip
  url: '/clips'
