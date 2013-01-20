define (require, exports, module) ->

  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'

  SOCKET_PORT = 8080

  exports.partyClient = Backbone.Model.extend

    idAttribute: '_id'

    url: () ->
      "/party/#{@id}"

    initialize: () ->
      # Create socket.io actions
      @socket = io.connect "http://localhost:#{SOCKET_PORT}"

      @socket.on 'addsong', (song) ->
        this.get('songs').push(data)

    hasSongs: () ->
      this.model.get('songs').length isnt 0

    nextSong: () ->
      # Pick next top rated song and play it
      next = _.max(this.get("songs"), (s) -> s.score)
      this.set("songs", _.select(this.model.get("songs"), (song) -> song isnt next))
      this.set("playing", next)

      @socket.emit('playsong', next)
