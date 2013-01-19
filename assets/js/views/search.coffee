define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  
  require '/lib/js/soundcloud.js'

  exports.search = Backbone.View.extend

    initialize: () ->
      console.log 'created search view'
      SC.initialize
        client_id: '0bc80f756a59625ed11e9791f107004a'

    searchYoutube: (str) ->
      # search youtube with the given string
      youtube_base_url = 'https://gdata.youtube.com/feeds/api/videos'
      params =
        q: str
        orderby: 'relevance'
        'start-index': 1
        alt: 'json'
        v: 2
        'max-results': 10
      url = "#{youtube_base_url}?#{$.param params}"
      $.get url, (data) -> console.log data.feed.entry

    searchSoundcloud: (str) ->
      # Search soundcloud with the given string
      SC.get '/tracks',
        q: str
        order: 'hotness'
        filter: 'streamable'
      , (tracks) -> console.log tracks

    searchSpotify: (str) ->
      # Search spotify with the given string
      spotify_base_url = 'http://ws.spotify.com/search/1/track'
      params =
        q: str
      url = "#{spotify_base_url}.json?#{$.param params}"
      $.get url, (data) -> console.log data    

    render: () ->
      this.$el.html(this.model.get 'name')
      return this