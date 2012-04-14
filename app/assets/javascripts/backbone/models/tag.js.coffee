class Clipin.Models.Tag extends Backbone.Model
  paramRoot: 'tag'

  defaults:
    name: null

class Clipin.Collections.TagsCollection extends Backbone.Collection
  model: Clipin.Models.Tag
  url: '/tags'
