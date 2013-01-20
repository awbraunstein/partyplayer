define (require, exports, module) ->

  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'

  SOCKET_PORT = 8080

  exports.PartyPlayer = Backbone.Model.extend

    idAttribute: '_id'

    url: () ->
      "/party/#{@id}"

    initialize: () ->
      # Create socket.io actions
      @socket = io.connect "http://localhost:#{SOCKET_PORT}"
      @socket.emit 'createparty', id: @id

      @socket.on 'addsong', (song) =>
        console.log '******* got new request ********'
        console.log song
        this.get('songs').push(song)

    hasSongs: () ->
      this.get('songs').length isnt 0

    nextSong: () ->
      # Pick next top rated song and play it
      next = _.max(this.get("songs"), (s) -> s.score)
      this.get("played").push(this.get("playing"))
      this.set("songs", _.select(this.get("songs"), (song) -> song isnt next))
      this.set("playing", next)

      @socket.emit('playsong', next)

      next
