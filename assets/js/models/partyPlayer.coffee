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
        this.get('songs').push(new Track(song))

    hasSongs: () ->
      this.get('songs').length isnt 0

    # Pick next top rated song and play it
    nextSong: () ->
      songs = @get('songs')
      next = songs.max (s) -> s.get('score')
      console.log next
      @get("played").push @get("playing")
      @set("songs", songs.select (song) -> song isnt next)
      @set("playing", next)

      @socket.emit('playsong', next)
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
