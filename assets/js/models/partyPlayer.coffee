define (require, exports, module) ->

  _         = require 'underscore'
  $         = require 'jquery'
  io        = require '/lib/js/socket.io.js'
  Backbone  = require 'backbone'
  Track     = require 'models/track'
  TrackList = require 'collections/trackList'

  SOCKET_PORT = 8080

  exports.PartyPlayer = Backbone.Model.extend

    idAttribute: '_id'

    url: () ->
      "/party/#{@id}"

    initialize: () ->
      # use Track models and collections for attributes
      track   = new Track @get('playing')
      played  = new TrackList @get('played')
      songs   = new TrackList @get('songs')
      @set 'playing', track
      @set 'played', played
      @set 'songs', songs

      @on 'change:songs', (data) =>
        if _.isArray(@get('songs'))
          @set 'songs', new TrackList @get('songs')

      console.log "currently playing #{track.get 'title'}..."
      @initSocketActions()

    # Register socket.io actions
    initSocketActions: () ->
      @socket = io.connect "http://#{window.location.hostname}:#{SOCKET_PORT}"
      @socket.emit 'createparty', id: @id

      @socket.on 'vote', (song) =>
        @get('songs').each (s) ->
          s.set('score', song.score) if s.get('uri') is song.uri

      @socket.on 'addsong', (song) =>
        console.log '******* got new request ********'
        console.log song
        @get('songs').add(new Track(song))

    # Pick next top rated song and play it, also broadcast on sockets
    getNextSong: () ->
      songs = @get 'songs'
      return null unless songs

      next = songs.max (s) -> s.get('score')

      # update played and playing
      if @get 'playing'
        @get('played').push @get('playing')
      @set('playing', next)

      # update request queue
      @get('songs').remove(next)

      @socket.emit 'playsong', next.attributes
      console.log '***** playing next... *****'
      console.log next
      next

    # Send a song request to the server
    sendNewRequest: (track) ->
      @socket.emit 'addsong', track

    # Send a vote request to the server
    voteSong: (uri, vote) ->
      @socket.emit 'vote',
        id: @id
        uri: uri
        vote: vote
