class Clipin.Models.OAuth extends Backbone.Model
  paramRoot: 'oauth'
  urlRoot: '/oauth/apps'

  defaults:
    name: null
    redirect_uri: null
    client_id: null
    client_secret : null

class Clipin.Collections.OAuthCollection extends Backbone.Collection
  model: Clipin.Models.OAuth
  url: '/oauth/apps'
