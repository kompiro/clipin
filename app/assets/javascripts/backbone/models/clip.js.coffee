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
    updated_at: null
    pin: false
    trash: false
    clip_count: 0
    user_id: null
    tags: []

  created_at_date:->
    moment(@get('created_at'))

  same_created_date:(target)->
    @created_at_date().format('YYYYMMDD') is target.created_at_date().format('YYYYMMDD')

  updated_at_date:->
    moment(@get('updated_at'))

  same_updated_date:(target)->
    @updated_at_date().format('YYYYMMDD') is target.updated_at_date().format('YYYYMMDD')

class Clipin.Collections.ClipsCollection extends Backbone.Collection
  model: Clipin.Models.Clip
  url: '/clips'

  comparator:(clip)->
    updated_at = clip.get('updated_at')
    if updated_at is null
      return Number.MIN_VALUE
    return - moment(updated_at).valueOf()
