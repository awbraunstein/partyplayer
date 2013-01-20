define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'

  require '/lib/js/soundcloud.js'

  exports.Search = Backbone.Model.extend

    initialize: () ->
      console.log 'created search model'
      SC.initialize
        client_id: '0bc80f756a59625ed11e9791f107004a'

    search: (str, callback) ->
      # callback has arguments provider and results
      @searchYoutube str, callback
      @searchSoundcloud str, callback

    searchYoutube: (str, callback) ->
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
      $.get url, (data) ->
        tracks = []
        for video in data.feed.entry
          tracks.push
            uri: video.media$group.yt$videoid.$t
            duration: parseInt(video.media$group.yt$duration.seconds) * 1000
            title: video.title.$t
            source: 'youtube'
            album_art: video['media$group']['media$thumbnail'][0].url
        callback('youtube', tracks)

    searchSoundcloud: (str, callback) ->
      # Search soundcloud with the given string
      SC.get '/search',
        q: str
        facet: 'model'
        limit: 15
        linked_partitioning: 1
      , (songs) ->
        tracks = []
        for song in songs.collection when song.kind is 'track' and song.streamable
          tracks.push
            uri: song.uri
            duration: song.duration
            title: song.title
            artist: song.user.username
            source: 'soundcloud'
            album_art: song.artwork_url
        callback('soundcloud', tracks)
