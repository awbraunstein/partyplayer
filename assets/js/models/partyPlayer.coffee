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

      # TODO

