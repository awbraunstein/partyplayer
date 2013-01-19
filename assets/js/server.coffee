define (require, exports, module) ->

  _  = require 'underscore'
  $  = require 'jquery'

  server =

    findParties: (coordinates, callback) ->
      console.log coordinates
      $.post '/nearby',
        latitude: coordinates.latitude
        longitude: coordinates.longitude
      , callback

  module.exports = server
