class Clipin.Models.Clip extends Backbone.Model
  paramRoot: 'clip'

  defaults:
    title: null
    og_type: null
    image: null
    url: null
    description: null
    audio: null
    video: null
    created_at: null

class Clipin.Collections.ClipsCollection extends Backbone.Collection
  model: Clipin.Models.Clip
  url: '/clips'
