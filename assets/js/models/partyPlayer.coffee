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

      @socket.on 'addsong', (song) =>
        console.log '******* got new request ********'
        console.log song
        this.get('songs').push(song)

    hasSongs: () ->
      this.get('songs').length isnt 0

    # Pick next top rated song and play it
    nextSong: () ->
      next = _.max(this.get("songs"), (s) -> s.score)
      this.get("played").push(this.get("playing"))
      this.set("songs", _.select(this.get("songs"), (song) -> song isnt next))
      this.set("playing", next)

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
