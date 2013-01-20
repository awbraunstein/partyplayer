define (require, exports, module) ->

  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'
  io        = require '/lib/js/socket.io.js'
  Track     = require 'models/track'
  TrackList = require 'collections/trackList'


  SOCKET_PORT = 8080

  exports.PartyClient = Backbone.Model.extend

    idAttribute: '_id'

    url: () ->
      "/party/#{@id}"

    initialize: () ->
      console.log this.toJSON()

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

      @socket.on 'connect', () =>
        @socket.emit 'joinparty',
          id: @id

      @socket.on 'populate', (party) =>
        # console.log "populate: #{party}"
        return null

      @socket.on 'playsong', (next) =>
        console.log '***** play new song *****'
        console.log next
        # Find the song with the given uri among the 'songs' collection
        nextTrack = @get('songs').find (song) ->
          song.get 'uri' == next.uri
        @get('played').push (@get 'playing')
        @set 'playing', nextTrack
        @get('songs').remove nextTrack

      @socket.on 'addsong', (song) =>
        console.log '***** got new request ******'
        console.log song
        # Add a new song to the request list
        newRequest = new Track song
        @get('songs').push newRequest

    # Send a song request to the server
    sendNewRequest: (track) ->
      @socket.emit 'addsong', track

    # Send a vote request to the server
    voteSong: (uri, vote) ->
      @socket.emit 'vote',
        id: @id
        uri: uri
        vote: vote

