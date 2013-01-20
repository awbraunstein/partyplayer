define (require, exports, module) ->

  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'
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

      @initSocketActions()

    # Register socket.io actions
    initSocketActions: () ->
      @socket = io.connect "http://localhost:#{SOCKET_PORT}"

      @socket.on 'connect', () =>
        console.log 'Connecting...'
        @socket.emit 'joinparty',
          id: @id

      @socket.on 'populate', (party) =>
        console.log 'Got a (socket) party!'
        console.log party

      @socket.on 'playsong', (next) =>
        console.log '***** play new song *****'
        console.log next
        # Find the song with the given uri among the 'songs' collection
        nextTrack = @get('songs').find (song) ->
          song.get 'uri' == next.uri
        @played.push (@get 'playing')
        @set 'playing', nextTrack
        @get('songs').remove nextTrack

      @socket.on 'addsong', (song) =>
        # Add a new song to the request list
        newRequest = new Track song
        @get('songs').push newRequest

    # Send a song request to the server
    sendNewRequest: (source, uri) ->
      @socket.emit 'addsong',
        id: @id
        uri: uri
        type: source

    # Send a vote request to the server
    voteSong: (uri, vote) ->
      @socket.emit 'vote',
        id: @id
        uri: uri
        vote: vote

